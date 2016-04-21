//
//  ResouceManager.m
//  BakeCake
//
//  Created by zhangchong on 8/20/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "ResouceManager.h"
#import "Constants.h"
#import "FMDB.h"
#import "FMDatabaseAdditions.h"
#import "Cake.h"
#import "Icing.h"
#import "Stuffing.h"
#import "Topping.h"
#import "CupCake.h"
#import "OrderCupcake.h"
#import "CustomerAddress.h"
#import "SysConfig.h"
#import "ProductPackage.h"
#import "GalleryItem.h"
#import "NewOrder.h"
#import "UserInfo.h"
#import "SysConfig.h"
#import "GalleryItem.h"
#import "CityStore.h"
#import "UserLocation.h"
#import "UserLocation.h"
#import "Store.h"
#import "DeliveryWay.h"
#import "PickByCustomer.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation ResouceManager

@synthesize db;
@synthesize timeoutTimer;
@synthesize memberID;
@synthesize isOrderSuccessfull;

+ (ResouceManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initDB];
    });
    
    return sharedInstance;
}

- (void)initData {
    CustomerAddress *address = [[CustomerAddress alloc] init];
    [self saveCustomerAddress:address];
    
    NewOrder *newOrder = [[NewOrder alloc] init];
    [self saveNewOrder:newOrder];
    
    DeliveryWay *deliveryWay = [[DeliveryWay alloc] init];
    [self saveDeliveryWay:deliveryWay];
    
    PickByCustomer *pbc = [[PickByCustomer alloc] init];
    [self savePickByCustomer:pbc];
    
    Topping *topping = [self queryToppingTalbe:kDefaultStuffingId];
    if (topping == nil) {
        Topping *defaultTopping = [[Topping alloc] init];
        defaultTopping.pid = kDefaultToppingId;
        defaultTopping.materialPrice = 0;
        defaultTopping.status = @"1";
        defaultTopping.selectPicName = @"none";
        defaultTopping.basicCakeType = [NSString stringWithFormat:@"%ld",MATERIAL_TYPE_TOPPING];
        [self insertBasicCake:defaultTopping];
    }
    
    
    Stuffing *stuffing = [self queryStuffingTalbe:kDefaultStuffingId];
    if (stuffing == nil) {
        Stuffing *defaultStuffing = [[Stuffing alloc] init];
        defaultStuffing.pid = kDefaultStuffingId;
        defaultStuffing.materialPrice = 0;
        defaultStuffing.status = @"1";
        defaultStuffing.selectPicName = @"none";
        defaultStuffing.basicCakeType = [NSString stringWithFormat:@"%ld",MATERIAL_TYPE_STUFFING];
       [self insertBasicCake:defaultStuffing];
    }
    
}


- (void)creatFolder {
    
    [self creatFolderImpl:kIMG_LOCAL_FOLDER];
    [self creatFolderImpl:kIMG_LOCAL_STORE_FOLDER];
    [self creatFolderImpl:kIMG_LOCAL_FLAVOR_FOLDER];
    [self creatFolderImpl:kIMG_LOCAL_CAKE_ICON_PATH];
    [self creatFolderImpl:kIMG_LOCAL_ICING_ICON_PATH];
    [self creatFolderImpl:kIMG_LOCAL_STUFFING_ICON_PATH];
    [self creatFolderImpl:kIMG_LOCAL_TOPPING_ICON_PATH];
    [self creatFolderImpl:kIMG_LOCAL_CAKE_PATH];
    [self creatFolderImpl:kIMG_LOCAL_ICING_PATH];
    [self creatFolderImpl:kIMG_LOCAL_TOPPING_PATH];
    [self creatFolderImpl:kIMG_LOCAL_STUFFING_PATH];
    [self creatFolderImpl:kIMG_LOCAL_CAKE_OVERLOOK_PATH];
    [self creatFolderImpl:kIMG_LOCAL_ICING_OVERLOOK_PATH];
    [self creatFolderImpl:kIMG_LOCAL_TOPPING_OVERLOOK_PATH];
    
    [self creatFolderImpl:kIMG_LOCAL_CAKE_OVERLOOK_FRONT_PATH];
    [self creatFolderImpl:kIMG_LOCAL_ICING_OVERLOOK_FRONT_PATH];
    [self creatFolderImpl:kIMG_LOCAL_TOPPING_OVERLOOK_FRONT_PATH];
}

- (void)copyFile {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"none.png" ofType:nil inDirectory:@"resource"];
    [defaultManager copyItemAtPath:filePath toPath:[NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_STUFFING_ICON_PATH,@"none.png"] error:nil];
    [defaultManager copyItemAtPath:filePath toPath:[NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_TOPPING_ICON_PATH,@"none.png"] error:nil];
}


- (void)creatFolderImpl:(NSString *)subfix {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destFolderPath = [NSString stringWithFormat:@"%@%@",[ResouceManager doucmentPath],subfix];
    
    if (![fileManager fileExistsAtPath:destFolderPath]) {
        [fileManager createDirectoryAtPath:destFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSURL *)getServerDownloadPath:(NSString *)remoteFileName {
    
    if (remoteFileName == nil) {
        return nil;
    }
    
    NSMutableString *downloadStr = [[NSMutableString alloc] init];
    [downloadStr appendString:kIMG_SERVER_URL];
    [downloadStr appendString:remoteFileName];
    NSURL *url = [NSURL URLWithString:downloadStr];
    return url;

}

- (void)downloadCupcakeResource:(int)requestTime
                    downloadPic:(BOOL)download
                         showUI:(BOOL)showUI
                           inVC:(UIViewController *)vc
                         pageNo:(NSUInteger)pageNo
                         cityId:(NSString *)cityId
                       pageSize:(NSUInteger)pageSize{
    LOG(@"下载材料");
    
    if (showUI) {
        if (![ResouceManager isExistenceNetwork]) {
            return;
        }
        [ProgressHUD show:@"请稍后"];
        [[ResouceManager sharedInstance] startLoading];
    }
    
    AFJSONRPCClient *materialClient =  [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:SMART_SERVICE_ENDPOINT]];
    NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
    
    if (cityId != nil) {
        [req setObject:cityId forKey:@"materialCity"];
    }
    
    [req setObject:[NSString stringWithFormat:@"%ld",pageNo] forKey:@"pageNo"];
    [req setObject:[NSString stringWithFormat:@"%ld",pageSize] forKey:@"pageSize"];
    [materialClient invokeMethod:@"getMaterialList" withParameters:@[req] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealwithDownloadingResource:responseObject downloadPic:download showUI:showUI inVC:vc cityId:cityId pageNo:pageNo pageSize:pageSize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"%@",[error localizedDescription]);
        
        if (showUI) {
            [ProgressHUD dismiss];
            [[ResouceManager sharedInstance] finishLoading];
        }
        
    }];
}

- (void)dealwithDownloadingResource:(id)responseObject
                        downloadPic:(BOOL)download
                             showUI:(BOOL)showUI
                               inVC:(UIViewController *)vc
                             cityId:(NSString *)cityId
                             pageNo:(NSUInteger)pageNo
                           pageSize:(NSUInteger)pageSize {
    if (responseObject == nil) {
        return;
    }
    
    NSDictionary *dic = (NSDictionary *)responseObject;
    NSString *repCode = [dic objectAvoidNullKey:@"repCode"];
    NSString *totalNum = [dic objectAvoidNullKey:@"totalNum"];

    if ([REQUEST_SUCCESS isEqualToString:repCode]) {
        NSString *repData = [dic objectAvoidNullKey:@"repData"];
        NSData *jsonData = [repData dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *list = [jsonData objectFromJSONData];
        
        BOOL isPicUpdate = NO;
        for (NSDictionary *ele in list) {

            BasicCake *basicCake = [[BasicCake alloc] initWithDic:ele];
            NSString *tableName = [self getTableName:basicCake];
            BasicCake *queryCake = [self queryBaiscTalbe:tableName pid:basicCake.pid];
            
            if (queryCake == nil) {
                LOG(@"未查询到pid=%@的蛋糕材料",basicCake.pid);
                [self insertBasicCake:basicCake];
                
                if (download) {
                    [self downloadPic:basicCake];
                }
            }else{
                //data compare
                //if basiccake.
                LOG(@"查询到pid=%@的蛋糕材料",queryCake.pid);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSDate *requestDate = [formatter dateFromString:basicCake.updateDate];
                NSDate *dbDate = [formatter dateFromString:queryCake.updateDate];
                
                NSComparisonResult result = [requestDate compare:dbDate];
                if (result == NSOrderedDescending) {
                    LOG(@"数据库更新时间<请求时图片的更新时间");
                    //更新数据库
                    [self updateBasicCake:basicCake];
                    
                    //删除已存在的图片
                    [self deleteBasicCakePic:basicCake];
                    
                    if (download) {
                        [self downloadPic:basicCake];
                    }

                    isPicUpdate = YES;
                }else if(result == NSOrderedSame) {
                    LOG(@"图片信息没有变化");
                    //更新数据库
                    [self updateBasicCake:basicCake];
                }else{
                    LOG(@"数据库更新时间>请求时图片的更新时间. error");
                }
            }
            
            if (isPicUpdate) {
                [SDWebImageManager.sharedManager.imageCache clearMemory];
                [SDWebImageManager.sharedManager.imageCache clearDisk];
            }
        }

        if (totalNum != nil && [totalNum length] > 0) {
            NSInteger total = [totalNum integerValue];
            if (pageNo * pageSize >= total) {
                LOG(@"已经获取全部的数据");

            }else {
                [self downloadCupcakeResource:1 downloadPic:download showUI:showUI inVC:vc pageNo:pageNo+1 cityId:cityId pageSize:pageSize];
            }
        }
    }else{
        if (showUI) {
            [ProgressHUD dismiss];
            [[ResouceManager sharedInstance] finishLoading];
        }
    }
    
    [db close];
}

- (void)deleteBasicCakePic:(BasicCake *)basicCake {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (basicCake.cutOverPicName) {
        NSString *destFolderPath = [NSString stringWithFormat:@"%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_CAKE_PATH];
        NSString *destFilePath = [NSString stringWithFormat:@"%@%@",destFolderPath,basicCake.cutOverPicName];
        
        if ([defaultManager fileExistsAtPath:destFolderPath]) {
            [defaultManager removeItemAtPath:destFilePath error:nil];
        }
        
    }
    
    if (basicCake.overLookPicName) {
        NSString *destFolderPath = [NSString stringWithFormat:@"%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_CAKE_OVERLOOK_PATH];
        NSString *destFilePath = [NSString stringWithFormat:@"%@%@",destFolderPath,basicCake.overLookPicName];
        
        if ([defaultManager fileExistsAtPath:destFolderPath]) {
            [defaultManager removeItemAtPath:destFilePath error:nil];
        }
    }
    
    if (basicCake.overLookFrontPicName) {
        NSString *destFolderPath = [NSString stringWithFormat:@"%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_CAKE_OVERLOOK_FRONT_PATH];
        NSString *destFilePath = [NSString stringWithFormat:@"%@%@",destFolderPath,basicCake.overLookFrontPicName];
        
        if ([defaultManager fileExistsAtPath:destFolderPath]) {
            [defaultManager removeItemAtPath:destFilePath error:nil];
        }
    }
    
    if (basicCake.selectPicName) {
        NSString *destFolderPath = [NSString stringWithFormat:@"%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_CAKE_ICON_PATH];
        NSString *destFilePath = [NSString stringWithFormat:@"%@%@",destFolderPath,basicCake.selectPicName];
        
        if ([defaultManager fileExistsAtPath:destFolderPath]) {
            [defaultManager removeItemAtPath:destFilePath error:nil];
        }
    }

}

- (void)downloadPic:(BasicCake *)basicCake {
    
    NSString *basicCakeType = basicCake.basicCakeType;
    
    if ([[NSString stringWithFormat:@"%ld",MATERIAL_TYPE_CAKE] isEqualToString:basicCakeType] ) {
        if (basicCake.cutOverPicName) {
            [self downloadPic:basicCake.cutOverPicServerName inDiretory:kIMG_LOCAL_CAKE_PATH];
        }
        
        if (basicCake.overLookPicName) {
            [self downloadPic:basicCake.overLookPicServerName inDiretory:kIMG_LOCAL_CAKE_OVERLOOK_PATH];
        }
        
        if (basicCake.overLookFrontPicName) {
            [self downloadPic:basicCake.overLookFrontPicServerName inDiretory:kIMG_LOCAL_CAKE_OVERLOOK_FRONT_PATH];
        }
        
        if (basicCake.selectPicName) {
            [self downloadPic:basicCake.selectPicServerName inDiretory:kIMG_LOCAL_CAKE_ICON_PATH];
        }
        
        
        
    }else if([[NSString stringWithFormat:@"%ld",MATERIAL_TYPE_ICING] isEqualToString:basicCakeType]) {
        if (basicCake.cutOverPicName) {
            [self downloadPic:basicCake.cutOverPicServerName inDiretory:kIMG_LOCAL_ICING_PATH];
        }
        
        if (basicCake.overLookPicName) {
            [self downloadPic:basicCake.overLookPicServerName inDiretory:kIMG_LOCAL_ICING_OVERLOOK_PATH];
        }
        
        if (basicCake.overLookFrontPicName) {
            [self downloadPic:basicCake.overLookFrontPicServerName inDiretory:kIMG_LOCAL_ICING_OVERLOOK_FRONT_PATH];
        }
        
        if (basicCake.selectPicName) {
            [self downloadPic:basicCake.selectPicServerName inDiretory:kIMG_LOCAL_ICING_ICON_PATH];
        }
    }else if([[NSString stringWithFormat:@"%ld",MATERIAL_TYPE_TOPPING] isEqualToString:basicCakeType]) {
        if (basicCake.cutOverPicName) {
            [self downloadPic:basicCake.cutOverPicServerName inDiretory:kIMG_LOCAL_TOPPING_PATH];
        }
        
        if (basicCake.overLookPicName) {
            [self downloadPic:basicCake.overLookPicServerName inDiretory:kIMG_LOCAL_TOPPING_OVERLOOK_PATH];
        }
        
        if (basicCake.overLookFrontPicName) {
            [self downloadPic:basicCake.overLookFrontPicServerName inDiretory:kIMG_LOCAL_TOPPING_OVERLOOK_FRONT_PATH];
        }
        
        if (basicCake.selectPicName) {
            [self downloadPic:basicCake.selectPicServerName inDiretory:kIMG_LOCAL_TOPPING_ICON_PATH];
        }
    }else if([[NSString stringWithFormat:@"%ld",MATERIAL_TYPE_STUFFING] isEqualToString:basicCakeType]) {
        if (basicCake.cutOverPicName) {
            [self downloadPic:basicCake.cutOverPicServerName inDiretory:kIMG_LOCAL_STUFFING_PATH];
        }
        
        if (basicCake.selectPicName) {
            [self downloadPic:basicCake.selectPicServerName inDiretory:kIMG_LOCAL_STUFFING_ICON_PATH];
        }
    }
    
}

- (NSString *)getFileName:(NSString *)filePathName {
    
    if (filePathName == nil) {
        return @"";
    }
    
    NSArray *filePathArray = [filePathName componentsSeparatedByString:@"/"];
    NSString *fileName = [filePathArray lastObject];
    return fileName;
}

- (void)downloadPic:(NSString *)picName inDiretory:(NSString *)path {
    
    NSMutableString *downloadStr = [[NSMutableString alloc] init];
    [downloadStr appendString:kIMG_SERVER_URL];
    [downloadStr appendString:picName];
    NSURL *url = [[NSURL alloc] initWithString:downloadStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //kIMG_LOCAL_FOLDER
            NSString *destFolderPath = [NSString stringWithFormat:@"%@%@",[ResouceManager doucmentPath],path];
            
            NSString *picRealName = [self getFileName:picName];
            NSString *destFilePath = [NSString stringWithFormat:@"%@%@",destFolderPath,picRealName];
            
            if (![fileManager fileExistsAtPath:destFolderPath]) {
                [fileManager createDirectoryAtPath:destFilePath withIntermediateDirectories:YES attributes:nil error:nil];
            }

            if ([fileManager fileExistsAtPath:destFilePath]) {
                NSError *delFileError = nil;
                [fileManager removeItemAtPath:destFilePath error:&delFileError];
            }
            
            [data writeToFile:destFilePath atomically:YES];
            
            LOG(@"%@",destFilePath);
        }else if ([data length] == 0 && connectionError == nil){
            LOG(@"Nothing was downloaded.");
        }else if (connectionError != nil){
            LOG(@"Error happened = %@",connectionError);
        }
    }];
}


- (void)requestDeliverCity {

    if (![ResouceManager isExistenceNetwork]) {
        return;
    }
    
    
    NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:SMART_SERVICE_ENDPOINT]];
    
    [client invokeMethod:@"getStoreList"
          withParameters:@[req]
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if (responseObject) {
                         LOG(@"%@",responseObject);
                         NSDictionary *dic = (NSDictionary *)responseObject;
                         NSString *repCode = [dic objectAvoidNullKey:@"repCode"];
                         if ([REQUEST_SUCCESS isEqualToString:repCode]) {
                             NSString *repData = [dic objectAvoidNullKey:@"repData"];
                             NSData *jsonData = [repData dataUsingEncoding:NSUTF8StringEncoding];
                             NSArray *list = [jsonData objectFromJSONData];
                             
                             if (list != nil && [list count] > 0) {
                                 [self deleteAllCity];
                                 NSUInteger count = [list count];
                                 for (int i= 0 ; i< count; i++) {
                                     NSDictionary *ele = [list objectAtIndex:i];
                                     CityStore *cityStore = [[CityStore alloc] initWithDic:ele];
                                     if (i == 0) {
                                         CityStore *currentCity = [self getCityStore];
                                         if (currentCity == nil) {
                                             [self saveCityStore:cityStore];
                                         }
                                     }
                                     [self insertCity:cityStore];
                                 }
                             }
                         }
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                 }];
}

#pragma mark 请求喜爱产品
- (void)downloadFlavorProduct {
    AFJSONRPCClient *client =  [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:SMART_SERVICE_ENDPOINT]];
    NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
    req[@"productMachine"] = @"1";
    [client invokeMethod:@"getProductList" withParameters:@[req] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            return;
        }
        
        LOG(@"%@",responseObject);
        
        if (responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSString *repCode = [dic objectAvoidNullKey:@"repCode"];
            if ([REQUEST_SUCCESS isEqualToString:repCode]) {
                NSString *repData = [dic objectAvoidNullKey:@"repData"];
                NSData *jsonData = [repData dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *list = [jsonData objectFromJSONData];
                
                for (NSDictionary *ele in list) {
                    ProductPackage *productPackage = [[ProductPackage alloc] initWithDic:ele showAll:YES];
                    NSMutableArray *productArray = productPackage.productArray;
                    for (int i=0; i< [productArray count]; i++) {
                        
                        if (PRODUCT_FLAVOR_CLASSIC == productPackage.type) {
                            FlavorCupcake *flavorCupcake = [productArray objectAtIndex:i];
                            //如果数据库中无喜爱的蛋糕产品，增加到数据库
                            FlavorCupcake *query = [[ResouceManager sharedInstance] queryShoppingCartFlaovrCupcake:flavorCupcake.productID];
                            if (query == nil) {
                                [[ResouceManager sharedInstance] insertShoppingCartFlaovrCupcake:flavorCupcake];
                            }else{
                                [[ResouceManager sharedInstance] updateShoppingCartFlaovrCupcake:flavorCupcake];
                            }
                            [[ResouceManager sharedInstance] closeDb];

                        }else if(PRODUCT_PRODUCT == productPackage.type) {
                            FlavorProduct *flavorProduct = [productArray objectAtIndex:i];
                            FlavorProduct *query = [[ResouceManager sharedInstance] queryShoppingCartFlaovrProduct:flavorProduct.productID];
                            if (query == nil) {
                                [[ResouceManager sharedInstance] insertShoppingCartFlaovrProduct:flavorProduct];
                            }else{
                                [[ResouceManager sharedInstance] updateShoppingCartFlaovrProduct:flavorProduct];
                            }
                            
                            [[ResouceManager sharedInstance] closeDb];
                        }
                    }
                    
                }
                
            }
        }
 
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"%@",[error localizedDescription]);
        
    }];
}

#pragma mark -
#pragma mark 下载系统参数配置
- (void)requestArgument:(int)requestTime {
    AFJSONRPCClient *client =  [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:SMART_SERVICE_ENDPOINT]];
    NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
    
    [client invokeMethod:@"getArgumentList" withParameters:@[req] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSString *repCode = [dic objectAvoidNullKey:@"repCode"];
        if ([REQUEST_SUCCESS isEqualToString:repCode]) {
            NSString *repData = [dic objectAvoidNullKey:@"repData"];
            NSData *jsonData = [repData dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *list = [jsonData objectFromJSONData];
            for (NSDictionary *ele in list) {
                SysConfig *config = [[SysConfig alloc] initWithDic:ele];
                [self saveUpdateSysconfig:config];
                LOG(@"%@",ele);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"%@",[error localizedDescription]);
    }];
}

- (NSString *)getResouceValue:(NSString *)key {
    NSString *value = NSLocalizedString(key,@"");
    return value;
}

- (UIImage *)imageWithContentsOfFile:(NSString *) imgName {
    return [UIImage imageNamed:imgName];
}

- (NSString *)savePNGImageFromImageView:(UIView *)view filePathName:(NSString *)fileName {
    
//    UIGraphicsBeginImageContext(view.bounds.size);

    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    if ([defaultFileManager fileExistsAtPath:fileName]) {
        [defaultFileManager removeItemAtPath:fileName error:nil];
    }
    
    if ([UIImagePNGRepresentation(image) writeToFile:fileName atomically:YES]) {
        LOG(@"Succeeded!");
    }

    UIGraphicsEndImageContext();
    return fileName;
}

+ (NSString *) randomStr:(NSString *)prefix {
    NSString *str = [NSString stringWithFormat:@"%@",prefix];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMdd"];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:zone];
    
    NSDate *nowdate = [NSDate date];
    NSString *formateStr = [formatter stringFromDate:nowdate];
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[nowdate timeIntervalSince1970]];
    
    str = [str stringByAppendingFormat:@"%@%@",formateStr,timestamp];
    return str;
}

+ (NSString *) appPath {
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    return appPath;
}

+ (NSString *) doucmentPath {
    NSArray *homeDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [homeDirectories objectAtIndex:0];
}

+ (NSString *) libraryPath {
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [libraryArray objectAtIndex:0];
}

+ (NSString *) chachesPath {
    NSArray *chachesArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [chachesArray objectAtIndex:0];
}

+ (NSString *) tmpPath {
    return NSTemporaryDirectory();
}

#pragma mark 保存系统信息
- (void)resetCustomerAddress {
    CustomerAddress *address = [[CustomerAddress alloc] init];
    [self saveCustomerAddress:address];
}

- (CustomerAddress *)getCustomerAddres {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *addressData = [defaults objectForKey:@"customerAddress1"];
    CustomerAddress *address = [NSKeyedUnarchiver unarchiveObjectWithData:addressData];
    return address;
    
}

- (void)saveCustomerAddress:(CustomerAddress *)address {
    
    if ([address isEqual:[NSNull null]]) {
        return;
    }
    
    if (address) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:address];
        [defaults setObject:addressData forKey:@"customerAddress1"];
        [defaults synchronize];
    }
}

- (void)resetNewOrder {
    NewOrder *newOrder = [[NewOrder alloc] init];
    [self saveNewOrder:newOrder];
}

- (NewOrder *)getNewOrder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *orderData = [defaults objectForKey:@"newOrder"];
    NewOrder *newOrder = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
    return newOrder;
    
}

- (void)saveNewOrder:(NewOrder *)newOrder {
    if ([newOrder isEqual:[NSNull null]]) {
        return;
    }
    
    if (newOrder) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *newOrderData = [NSKeyedArchiver archivedDataWithRootObject:newOrder];
        [defaults setObject:newOrderData forKey:@"newOrder"];
        [defaults synchronize];
    }
}

- (void)resetDeliveryWay {
    DeliveryWay *delivery = [[DeliveryWay alloc] init];
    [self saveDeliveryWay:delivery];
}

- (DeliveryWay *)getDeliveryWay {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *deliveryWayData = [defaults objectForKey:@"deliveryWay"];
    DeliveryWay *deliveryWay = [NSKeyedUnarchiver unarchiveObjectWithData:deliveryWayData];
    return deliveryWay;
    
}

- (void)saveDeliveryWay:(DeliveryWay *)dw {
    if ([dw isEqual:[NSNull null]]) {
        return;
    }
    
    if (dw) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *dwData = [NSKeyedArchiver archivedDataWithRootObject:dw];
        [defaults setObject:dwData forKey:@"deliveryWay"];
        [defaults synchronize];
    }
}

- (void)resetPickByCustomer {
    PickByCustomer *pbc = [[PickByCustomer alloc] init];
    [self savePickByCustomer:pbc];
}

- (PickByCustomer *)getPickByCustomer {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *pbcData = [defaults objectForKey:@"pickByCustomer"];
    PickByCustomer *pbc = [NSKeyedUnarchiver unarchiveObjectWithData:pbcData];
    return pbc;
    
}

- (void)savePickByCustomer:(PickByCustomer *)pbc {
    if ([pbc isEqual:[NSNull null]]) {
        return;
    }
    
    if (pbc) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *pbcData = [NSKeyedArchiver archivedDataWithRootObject:pbc];
        [defaults setObject:pbcData forKey:@"pickByCustomer"];
        [defaults synchronize];
    }
}


- (UserInfo *)getUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *infoData = [defaults objectForKey:@"UserInfo"];
    UserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
    return userInfo;
    
}

- (void)saveUserInfo:(UserInfo *)userInfo {
    if ([userInfo isEqual:[NSNull null]]) {
        return;
    }
    
    if (userInfo) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *newOrderData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        [defaults setObject:newOrderData forKey:@"UserInfo"];
        [defaults synchronize];
    }
}


- (void)resetCurrentCity {
    CityStore *city = [[CityStore alloc] init];
    [self saveCityStore:city];
}

- (CityStore *)getCityStore {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *cityData = [defaults objectForKey:@"currentCity"];
    CityStore *city = [NSKeyedUnarchiver unarchiveObjectWithData:cityData];
    return city;
    
}

- (void)saveCityStore:(CityStore *)city {
    
    if ([city isEqual:[NSNull null]]) {
        return;
    }
    
    if (city) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:city];
        [defaults setObject:cityData forKey:@"currentCity"];
        [defaults synchronize];
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view =[ [UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark -
#pragma mark 开启位置服务向服务器发送位置信息
- (void)sendUserLocationForBetterService:(UserLocation *)loc {
    AFJSONRPCClient *client =  [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:SMART_SERVICE_ENDPOINT]];
    NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
    [req setObject:loc.memberPhone forKey:@"memberPhone"];
    [req setObject:loc.reqLocKind forKey:@"reqLocKind"];
    [req setObject:loc.longitude forKey:@"longitude"];
    [req setObject:loc.latitude forKey:@"latitude"];
    [req setObject:loc.city forKey:@"city"];
    [req setObject:loc.detailedAdd forKey:@"detailedAdd"];
    [req setObject:loc.updateTime forKey:@"updateTime"];

    
    [client invokeMethod:@"addMemberLogInfo" withParameters:@[req] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            return;
        }
        
        LOG(@"%@",responseObject);
        
        if (responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSString *repCode = [dic objectAvoidNullKey:@"repCode"];
            if ([REQUEST_SUCCESS isEqualToString:repCode]) {
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"%@",[error localizedDescription]);
        
    }];

}


+ (BOOL)isExistenceNetwork {
//    BOOL isExistenceNetwork = FALSE;
//    Reachability *reachability = [Reachability reachabilityWithHostName:kServerAddress];  // 测试服务器状态
//    
//    switch([reachability currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork = FALSE;
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = TRUE;
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = TRUE;
//            break;
//    }
//    
//    if (!isExistenceNetwork) {
//        [ProgressHUD showError:@"似乎断开与互联网的连接"];
//    }
//    return  isExistenceNetwork;
    return TRUE;
}

+ (BOOL)isExistenceBcupService
{
//    BOOL isExistenceNetwork = FALSE;
//    Reachabilities *reachability = [Reachabilities reachabilityWithHostName:kBcupLoginAddress];  // 测试服务器状态
//    
//    switch([reachability currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork = FALSE;
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = TRUE;
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = TRUE;
//            break;
//    }
//    
//    if (!isExistenceNetwork) {
//        [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
//            
//        }];
//        
//        [ProgressHUD showError:@"似乎服务端正在维护"];
//    }
//    return  isExistenceNetwork;
    return YES;
}

#pragma mark -
#pragma mark 数据库相关操作
- (void)closeDb {
    [db close];
}

- (void)destoryDB:(NSString *)dbPath {
    db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        LOG(@"could not open db");
    }
    [db executeUpdate:@"drop table STOREINFO"];
    [db executeUpdate:@"drop table GALLERYCUPCAKE"];
    [db executeUpdate:@"drop table CAKE"];
    [db executeUpdate:@"drop table ICING"];
    [db executeUpdate:@"drop table TOPPING"];
    [db executeUpdate:@"drop table STUFFING"];
}

#pragma mark 数据库创建
- (void)createDB {
    //送货城市
    [db executeUpdate:@"create table city(cityID text, cityName text,cityRange text, updateTime text,cityPic text, PRIMARY KEY(cityID))"];
    
    [db executeUpdate:@"CREATE TABLE Store(storeID text PRIMARY KEY NOT NULL,storeCityID text, storeName text,     storePhone text,storeLatitude text, storeLongitude text, storeAddress text, storeWorktime text,     storeSaturdayWorkTime text, storeSundayWorkTime text, updateTime text);"];
    
    //创建系统参数表
    [db executeUpdate:@"CREATE TABLE SysConfig (argumentKey text,argumentValue text,PRIMARY KEY(argumentKey));"];
    
    //收藏夹
    [db executeUpdate:@"create table GALLERYCUPCAKE(customID text,CAKE_G_PID text,ICING_G_PID text,TOPPING_G_PID text,STUFFING_G_PID text,type text,memeberId text,memeberPhone text,flavor_pid text,name text,cakeType text,cakePrice text,creator text,lookOverPicAddress text, cutoverpicaddress text,isSendPublicGallery text,createTime text,updateTime text,PRIMARY KEY(CAKE_G_PID,ICING_G_PID,TOPPING_G_PID,STUFFING_G_PID,flavor_pid))"];
    //end收藏夹蛋糕
    
    
    //创建购物车-产品表
    [db executeUpdate:@"CREATE TABLE FlavorProduct (productID text,productName text,productPrice text,productTime text, productKind text,productType text,productState text,productDes text,cutPic text,overPic text,overServerPic text,ppBackgroundPic text, ppBackgroundServerPic text, cakePid text,icingPid text,toppingPid text,stuffingPid text,updateTime text,PRIMARY KEY (productID))"];
    
    //创建购物车表
    [db executeUpdate:@"CREATE TABLE SHOPPINGCART (MEMEBERID text NOT NULL,MEMEBERPHONE text,TYPE text,CAKEPID text,ICINGPID text,TOPPINGPID text,STUFFINGPID text,CREATETIME text,UPDATETIME text,PRODUCT_NUM text,PRODUCT_DISPLAY_PIC_NAME text,FLAVOR_PID text);"];
    
    //蛋糕主体
    [db executeUpdate:@"create table CAKE(PID text,MATERIALNAME text,CUTOVERPICNAME text,OVERLOOKPICNAME text,OVERLOOKFRONTPICNAME text,SELECTPICNAME text,MATERIALPRICE text, UPDATEDATE text,STATUS text,cutOverPicServerName text,overLookPicServerName text,selectPicServerName text, overLookFrontPicServerName text,cityIds text,PRIMARY KEY(PID))"];

    //奶油
    [db executeUpdate:@"create table ICING(PID text,MATERIALNAME text,CUTOVERPICNAME text,OVERLOOKPICNAME text,OVERLOOKFRONTPICNAME text,SELECTPICNAME text,MATERIALPRICE text, UPDATEDATE text,STATUS text,cutOverPicServerName text,overLookPicServerName text,selectPicServerName text, overLookFrontPicServerName text,cityIds text,PRIMARY KEY(PID))"];
    
    //装饰
    [db executeUpdate:@"create table TOPPING(PID text,MATERIALNAME text,CUTOVERPICNAME text,OVERLOOKPICNAME text,OVERLOOKFRONTPICNAME text,SELECTPICNAME text,MATERIALPRICE text, UPDATEDATE text,STATUS text,cutOverPicServerName text,overLookPicServerName text,selectPicServerName text, overLookFrontPicServerName text,cityIds text,PRIMARY KEY(PID))"];
    
    //内陷
    [db executeUpdate:@"create table STUFFING(PID text,MATERIALNAME text,CUTOVERPICNAME text,OVERLOOKPICNAME text,OVERLOOKFRONTPICNAME text,SELECTPICNAME text,MATERIALPRICE text, UPDATEDATE text,STATUS text,cutOverPicServerName text,overLookPicServerName text,selectPicServerName text, overLookFrontPicServerName text,cityIds text,PRIMARY KEY(PID))"];
    
}


#pragma mark 初始化数据库
- (void)initDB {
    NSString *dbPath = [[ResouceManager doucmentPath] stringByAppendingPathComponent:DBNAME];
    
    LOG(@"数据库地址:%@",dbPath);

    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:dbPath]) {
        
        if (isRelease) {
            //copy db to dbpath
            NSString *dbSourcePath = [[NSBundle mainBundle] pathForResource:DBNAME ofType:nil];
            [defaultManager copyItemAtPath:dbSourcePath toPath:dbPath error:nil];
            
            
            //copy pic
            NSString *picResoucePath = [dbSourcePath stringByReplacingOccurrencesOfString:DBNAME withString:kIMG_LOCAL_FOLDER];
            LOG(@"%@",[[NSBundle mainBundle] pathForResource:@"cupcake.db" ofType:nil]);
            LOG(@"pic path : %@",picResoucePath);
            
            NSString *pidDestPath = [[ResouceManager doucmentPath] stringByAppendingPathComponent:kIMG_LOCAL_FOLDER];
            [defaultManager copyItemAtPath:picResoucePath toPath:pidDestPath error:nil];
            db = [FMDatabase databaseWithPath:dbPath];
            [db open];
        }else{
            db = [FMDatabase databaseWithPath:dbPath];
            [db open];
            [self createDB];
        }
    }else{
        db = [FMDatabase databaseWithPath:dbPath];
        [db open];
    }
}

#pragma mark 参数表
- (void)saveUpdateSysconfig:(SysConfig *)config {
    if (![db open]) {
        return;
    }
    
    if (config == nil) {
        return;
    }
    
    [db beginTransaction];
    //删除数据
    [db executeUpdate:@"delete from SysConfig where argumentKey = ?",config.argumentKey];
    //插入数据
    [db executeUpdate:@"insert into SysConfig (argumentKey,argumentValue) values(?,?)",
     config.argumentKey,config.argumentValue];
        
    [db commit];
    [db close];

}

- (NSMutableArray *)queryCityStores {
    NSMutableArray *cities = [[NSMutableArray alloc] init];
    if (![db open]) {
        return cities;
    }

    NSString *queryStr = @"select * from city";
    FMResultSet *rs = [db executeQuery:queryStr];
    while ([rs next]) {
        NSDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[rs stringForColumn:@"cityID"] forKey:@"cityID"];
        [dic setValue:[rs stringForColumn:@"cityName"] forKey:@"cityName"];
        [dic setValue:[rs stringForColumn:@"cityPic"] forKey:@"cityPic"];
        [dic setValue:[rs stringForColumn:@"updateTime"] forKey:@"updateTime"];
        [dic setValue:[rs stringForColumn:@"cityRange"] forKey:@"cityRange"];
        
        CityStore *cityStore = [[CityStore alloc] initWithDic:dic];
        
        NSMutableArray *stores = [self queryStoreInCity:cityStore.cityID];
        cityStore.stores = stores;
        [cities addObject:cityStore];
        
    }
    [db close];
    return cities;
}

- (CityStore *)queryCity:(NSString *)cityId {
    if (cityId == nil) {
        return nil;
    }
    
    if (![db open]) {
        return nil;
    }
    
    
    
    NSString *queryStr = @"select * from city where cityID = ?";
    FMResultSet *rs = [db executeQuery:queryStr,cityId];
    if ([rs next]) {
        
        NSDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[rs stringForColumn:@"cityID"] forKey:@"cityID"];
        [dic setValue:[rs stringForColumn:@"cityName"] forKey:@"cityName"];
        [dic setValue:[rs stringForColumn:@"cityPic"] forKey:@"cityPic"];
        [dic setValue:[rs stringForColumn:@"updateTime"] forKey:@"updateTime"];
        [dic setValue:[rs stringForColumn:@"cityRange"] forKey:@"cityRange"];
        
        CityStore *city = [[CityStore alloc] initWithDic:dic];
        [db close];
        return city;
    }
    
    return nil;

}


- (void)deleteAllCity {
    if (![db open]) {
        return;
    }
    
    [db beginTransaction];
    [db executeUpdate:@"delete from city"];
    [db executeUpdate:@"delete from store"];
    [db commit];
    [db close];
}


- (void)updateCity:(CityStore *)store {
    if (store == nil) {
        return;
    }
    
    CityStore *query = [self queryCity:store.cityID];
    
    if (query == nil) {
        [self insertCity:store];
    }else{
        if (![db open]) {
            return;
        }
        
        NSString *executeStr = @"update city set cityName = ? , cityRange = ? updateTime = ? , cityPic = ? where cityID = ?";
        
        [db beginTransaction];
        [db executeUpdate:executeStr,
         store.cityName,
         store.cityRange,
         store.updateTime,
         store.cityPic,
         store.cityID
         ];
        
        [db commit];
        [db close];
    }
}

- (void)insertCity:(CityStore *)cityStore {
    if (![db open]) {
        return;
    }
    
    [db beginTransaction];
    [db executeUpdate:@"insert into city(cityID, cityName,cityRange, updateTime, cityPic) values(?,?,?,?,?)",
     cityStore.cityID,
     cityStore.cityName,
     cityStore.cityRange,
     cityStore.updateTime,
     cityStore.cityPic
     ];

    for (Store *store in cityStore.stores) {
        [self insertStore:store];
    }
    
    [db commit];
    [db close];
}

- (void)insertStore:(Store *)store {
    [db executeUpdate:@"insert into store(storeID,storeCityID,storeName,storePhone, storeLatitude,storeLongitude,storeAddress,storeWorktime,storeSaturdayWorkTime,storeSundayWorkTime,updateTime) values(?,?,?,?,?,?,?,?,?,?,?)",
     store.storeID,
     store.storeCityID,
     store.storeName,
     store.storePhone,
     store.storeLatitude,
     store.storeLongitude,
     store.storeAddress,
     store.storeWorktime,
     store.storeSaturdayWorkTime,
     store.storeSundayWorkTime,
     store.updateTime
     ];

}

- (NSMutableArray *)queryStoreInCity:(NSString *)cityId {
    NSMutableArray *stores = [[NSMutableArray alloc] init];
    if (![db open]) {
        return stores;
    }
    
    if (cityId == nil || [cityId length] == 0) {
        return stores;
    }
    
    NSString *queryStr = @"select * from store where storeCityID = ?";
    FMResultSet *rs = [db executeQuery:queryStr,cityId];
    while ([rs next]) {
        
        NSDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[rs stringForColumn:@"storeID"] forKey:@"storeID"];
        [dic setValue:[rs stringForColumn:@"storeCityID"] forKey:@"storeCity"];
        [dic setValue:[rs stringForColumn:@"storeName"] forKey:@"storeName"];
        [dic setValue:[rs stringForColumn:@"storePhone"] forKey:@"storePhone"];
        [dic setValue:[rs stringForColumn:@"storeLatitude"] forKey:@"storeLatitude"];
        [dic setValue:[rs stringForColumn:@"storeLongitude"] forKey:@"storeLongitude"];
        [dic setValue:[rs stringForColumn:@"storeAddress"] forKey:@"storeAddress"];
        [dic setValue:[rs stringForColumn:@"storeWorktime"] forKey:@"storeWorktime"];
        [dic setValue:[rs stringForColumn:@"storeSaturdayWorkTime"] forKey:@"storeSaturdayWorkTime"];
        [dic setValue:[rs stringForColumn:@"storeSundayWorkTime"] forKey:@"storeSundayWorkTime"];
        [dic setValue:[rs stringForColumn:@"updateTime"] forKey:@"updateTime"];
        
        Store *store = [[Store alloc] initWithDic:dic];
        [stores addObject:store];
    }
    
    return stores;
}

- (SysConfig *)querySysconfig:(NSString *)argumentKey {
    if (![db open]) {
        return nil;
    }
    
    if (argumentKey == nil || [argumentKey length] == 0) {
        return nil;
    }
    
    NSString *queryStr = @"select * from SysConfig where argumentKey = ?";
    FMResultSet *rs = [db executeQuery:queryStr,argumentKey];
    if ([rs next]) {
        
        NSDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[rs stringForColumn:@"argumentKey"] forKey:@"argumentKey"];
        [dic setValue:[rs stringForColumn:@"argumentValue"] forKey:@"argumentValue"];
        
        SysConfig *config = [[SysConfig alloc] initWithDic:dic];
        [db close];
        return config;
    }
    
    [db close];
    return nil;
    
}

- (NSString *)getTableName:(BasicCake *)basicCake {
    NSString *table = @"";
    
    if ([[NSString stringWithFormat:@"%lu",(unsigned long)MATERIAL_TYPE_STUFFING] isEqualToString:basicCake.basicCakeType]) {
        table = @"STUFFING";
    }else if ([[NSString stringWithFormat:@"%lu",(unsigned long)MATERIAL_TYPE_ICING] isEqualToString:basicCake.basicCakeType]) {
        table = @"ICING";
    }else if ([[NSString stringWithFormat:@"%lu",(unsigned long)MATERIAL_TYPE_CAKE] isEqualToString:basicCake.basicCakeType]) {
        table = @"CAKE";
    }else if ([[NSString stringWithFormat:@"%lu",(unsigned long)MATERIAL_TYPE_TOPPING] isEqualToString:basicCake.basicCakeType]) {
        table = @"TOPPING";
    }
    
    return table;
}

#pragma mark 材料表数据插入方法
- (void)insertBasicCake:(BasicCake *)basicCake {
    if (![db open]) {
        return;
    }
    
    if (basicCake == nil) {
        return;
    }
    [db beginTransaction];
    
    NSString *tableName = [self getTableName:basicCake];

    NSString *executeStr = [NSString stringWithFormat:@"insert into %@ (PID ,MATERIALNAME ,CUTOVERPICNAME ,cutOverPicServerName,OVERLOOKPICNAME ,overLookPicServerName,OVERLOOKFRONTPICNAME,overLookFrontPicServerName,SELECTPICNAME ,selectPicServerName,MATERIALPRICE, cityIds,UPDATEDATE ,STATUS) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",tableName];

    
    [db executeUpdate:executeStr,
     basicCake.pid,
     basicCake.materialName,
     basicCake.cutOverPicName,
     basicCake.cutOverPicServerName,
     basicCake.overLookPicName,
     basicCake.overLookPicServerName,
     basicCake.overLookFrontPicName,
     basicCake.overLookFrontPicServerName,
     basicCake.selectPicName,
     basicCake.selectPicServerName,
     [NSString stringWithFormat:@"%lf",basicCake.materialPrice],
     basicCake.cityIds,
     basicCake.updateDate,
     basicCake.status
     ];
    [db commit];
}

/*
#pragma mark 收藏夹表数据插入方法
- (void)insertBasicCake_G:(BasicCake *)basicCake tableName:(NSString *)tableName {
    
    if (basicCake == nil) {
        return;
    }
    
    BasicCake *querycake = [self queryBaiscTalbe:tableName pid:basicCake.pid];
    if (querycake != nil) {
        LOG(@"%@ 存在 %@",tableName, basicCake.pid);
        return ;
    }
    

    if (![db open]) {
        return;
    }
    
    
    [db beginTransaction];
    
    NSString *executeStr = [NSString stringWithFormat:@"insert into %@ (PID ,MATERIALNAME ,CUTOVERPICNAME ,cutOverPicServerName,OVERLOOKPICNAME ,overLookPicServerName,OVERLOOKFRONTPICNAME,overLookFrontPicServerName,SELECTPICNAME ,selectPicServerName,MATERIALPRICE , UPDATEDATE ,STATUS) values(?,?,?,?,?,?,?,?,?,?,?,?,?)",tableName];
    
    
    [db executeUpdate:executeStr,
     basicCake.pid,
     basicCake.materialName,
     basicCake.cutOverPicName,
     basicCake.cutOverPicServerName,
     basicCake.overLookPicName,
     basicCake.overLookPicServerName,
     basicCake.overLookFrontPicName,
     basicCake.overLookFrontPicServerName,
     basicCake.selectPicName,
     basicCake.selectPicServerName,
     [NSString stringWithFormat:@"%lf",basicCake.materialPrice],
     basicCake.updateDate,
     basicCake.status
     ];
    [db commit];
    [db close];
}
*/

- (NSString *)getToppingPid:(CupCake *)cupcake {
    
    if (cupcake == nil) {
        return kDefaultToppingId;
    }
    
    NSString *toppingPid = kDefaultToppingId;
    if (cupcake.topping) {
        toppingPid = cupcake.topping.pid;
    }
    
    return toppingPid;
}

- (NSString *)getStuffingPid:(CupCake *)cupcake {
    if (cupcake == nil) {
        return kDefaultStuffingId;
    }
    
    NSString *stuffingPid = kDefaultStuffingId;
    if (cupcake.stuffing) {
        stuffingPid = cupcake.stuffing.pid;
    }
    
    return stuffingPid;
}

#pragma mark 收藏夹查找
- (GalleryItem *)getGalleryItem:(GalleryItem *)searchItem {
    if (searchItem == nil) {
        return nil;
    }
    GalleryItem *queryItem = nil;
    
    UserInfo *user = [[ResouceManager sharedInstance] getUserInfo];
    
    NSString *userId = @"";
    NSString *userPhone = @"";
    if (user) {
        userId = user.memberID;
        userPhone = user.memberPhone;
    }
    

    if ([@"1" isEqualToString:searchItem.type]) {
        CupCake *cupcake = searchItem.cupcake;
        queryItem = [self getCupcakeFromGallery:cupcake.cake.pid icingId:cupcake.icing.pid toppingId:[self getToppingPid:cupcake] stuffingId:[self getStuffingPid:cupcake] flaoverId:@"" userId:userId userPhone:userPhone];
    }else if([@"2" isEqualToString:searchItem.type]) {
        CupCake *cupcake = searchItem.flavorCupcake.cupcake;
        queryItem = [self getCupcakeFromGallery:cupcake.cake.pid icingId:cupcake.icing.pid toppingId:[self getToppingPid:cupcake] stuffingId:[self getStuffingPid:cupcake] flaoverId:searchItem.flavorCupcake.productID userId:userId userPhone:userPhone];
    }else if([@"3" isEqualToString:searchItem.type]) {
        FlavorProduct *product = searchItem.flavorProduct;
        
        queryItem = [self getCupcakeFromGallery:@"" icingId:@"" toppingId:@"" stuffingId:@"" flaoverId:product.productID userId:userId userPhone:userPhone];
    }
    
    
    
    return queryItem;
    
}


- (GalleryItem *)getCupcakeFromGallery:(NSString *)cakePid
                           icingId:(NSString *)icingPid
                         toppingId:(NSString *)toppingPid
                        stuffingId:(NSString *)stuffingPid
                         flaoverId:(NSString *)flavorId
                            userId:(NSString *)userId
                         userPhone:(NSString *)userPhone{
    
    if (![db open]) {
        return nil;
    }
    
    NSString *queryStr = @"select * from GALLERYCUPCAKE where CAKE_G_PID = ? and ICING_G_PID = ? and TOPPING_G_PID = ? and STUFFING_G_PID = ? and memeberId = ? and memeberPhone = ? and flavor_pid = ?";

    FMResultSet *rs = [db executeQuery:queryStr,cakePid,icingPid,toppingPid,stuffingPid,userId,userPhone,flavorId];
    if ([rs next]) {
        
        NSString *type = [rs stringForColumn:@"type"];
        GalleryItem *item = nil;
        if ([@"1" isEqualToString:type]) {
            Cake *cake = [self queryCakeTalbe:cakePid];
            Icing *icing = [self queryIcingTalbe:icingPid];
            Topping *topping = [self queryToppingTalbe:toppingPid];
            Stuffing *stuffing = [self queryStuffingTalbe:stuffingPid];

            CupCake *ret = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
            item = [[GalleryItem alloc] initWithCupcake:ret];
            item.memeberId = [rs stringForColumn:@"memeberId"];
            item.memeberPhone = [rs stringForColumn:@"memeberPhone"];
//            item.flavor_pid = [rs stringForColumn:@"flavor_pid"];
            item.creator = [rs stringForColumn:@"CREATOR"];
            item.cakeName = [rs stringForColumn:@"NAME"];
            item.cakeType = [rs stringForColumn:@"CAKETYPE"];
        }else if([@"2" isEqualToString:type]) {
            Cake *cake = [self queryCakeTalbe:cakePid];
            Icing *icing = [self queryIcingTalbe:icingPid];
            Topping *topping = [self queryToppingTalbe:toppingPid];
            Stuffing *stuffing = [self queryStuffingTalbe:stuffingPid];
            FlavorCupcake *flavorCupcake = [[FlavorCupcake alloc] init];
            
            flavorCupcake.cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
            item = [[GalleryItem alloc] initWithFlavorCupcake:flavorCupcake];
            item.memeberId = [rs stringForColumn:@"memeberId"];
            item.memeberPhone = [rs stringForColumn:@"memeberPhone"];
//            item.flavor_pid = [rs stringForColumn:@"flavor_pid"];
            item.creator = [rs stringForColumn:@"CREATOR"];
            item.cakeName = [rs stringForColumn:@"NAME"];
            item.cakeType = [rs stringForColumn:@"CAKETYPE"];
        }else if([@"3" isEqualToString:type]){
            
            NSString *flaovrId = [rs stringForColumn:@"flavor_pid"];
            FlavorProduct *flavorProduct = [self queryShoppingCartFlaovrProduct:flaovrId];
            if (flavorProduct != nil) {
                item = [[GalleryItem alloc] initWithFlavorProduct:flavorProduct];
                item.memeberId = [rs stringForColumn:@"memeberId"];
                item.memeberPhone = [rs stringForColumn:@"memeberPhone"];
                item.creator = [rs stringForColumn:@"CREATOR"];
                item.cakeName = [rs stringForColumn:@"NAME"];
                item.cakeType = [rs stringForColumn:@"CAKETYPE"];
            }
            
        }

        [db close];
        return item;
    }
    
    [db close];
    return nil;
}

/*
#pragma mark 保存收藏CupCake
- (void)insertGalleryCupcake:(CupCake *)cupcake {
    if (![db open]) {
        return;
    }
    
    if (cupcake == nil) {
        return;
    }
    
   
    NSString *cakePid = nil;
    if (cupcake.cake) {
        cakePid = cupcake.cake.pid;
//        [self insertBasicCake_G:cupcake.cake tableName:@"CAKE_G"];
    }
    
    NSString *icingPid = nil;
    if (cupcake.icing) {
        icingPid = cupcake.icing.pid;
//        [self insertBasicCake_G:cupcake.icing tableName:@"ICING_G"];
    }
    
    NSString *toppingPid = kDefaultToppingId;
    if (cupcake.topping) {
        toppingPid = cupcake.topping.pid;
//        if (![kDefaultToppingId isEqualToString:toppingPid]) {
//            [self insertBasicCake_G:cupcake.topping tableName:@"TOPPING_G"];
//        }
    }
    
    NSString *stuffingPid = kDefaultStuffingId;
    if (cupcake.stuffing) {
        stuffingPid = cupcake.stuffing.pid;
//        if (![kDefaultStuffingId isEqualToString:stuffingPid]) {
//            [self insertBasicCake_G:cupcake.stuffing tableName:@"STUFFING_G"];
//        }
    }
   
    [db open];
    [db beginTransaction];

    
    [db executeUpdate:@"insert into GALLERYCUPCAKE(CAKE_G_PID ,ICING_G_PID ,TOPPING_G_PID ,STUFFING_G_PID,type,memeberId,memeberPhone,flavor_pid,NAME,cakeType,cakePrice,creator,lookOverPicAddress,cutoverpicaddress,isSendPublicGallery,createTime,updateTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
     cupcake.cake.pid,
     cupcake.icing.pid,
     toppingPid,
     stuffingPid,
     @"1",
     @"",
     @"",
     @"",
     cupcake.cakeName,
     cupcake.cakeType,
     @"",
     cupcake.creator,
     @"",
     @"",
     cupcake.isSendPublicGallery,
     [[NSDate date] getCurrentTime],
     [[NSDate date] getCurrentTime]
     ];
    [db commit];
    [db close];
}
*/

#pragma mark 从购物车保存到收藏夹,定制保存到收藏夹

- (void)insertGalleryOrderCupcake:(OrderCupcake *)occ user:(UserInfo *)user {
    if (occ == nil) {
        return;
    }
    
    GalleryItem *item = nil;
    if ([@"1" isEqualToString:occ.type]) {
        item = [[GalleryItem alloc] initWithCupcake:occ.cupcake];
    }else if ([@"2" isEqualToString:occ.type]) {
        item = [[GalleryItem alloc] initWithFlavorCupcake:occ.flavorCupcake];
    }else if ([@"3" isEqualToString:occ.type]) {
        item = [[GalleryItem alloc] initWithFlavorProduct:occ.flavorProduct];
    }
    
    [self insertGalleryCupcakeOrderCupcake:item user:user];
    
}

- (void)insertGalleryCupcakeOrderCupcake:(GalleryItem *)item user:(UserInfo *)user {
    
    if (![db open]) {
        return;
    }
    
    if (item == nil) {
        return;
    }
    
    
    
    [db open];
    [db beginTransaction];
    
    
    if ([@"1" isEqualToString:item.type]) {
        CupCake *cupcake = item.cupcake;
        
        NSString *toppingPid = [self getToppingPid:cupcake];
        NSString *stuffingPid = [self getStuffingPid:cupcake];
        NSString *memeberId = @"";
        NSString *memeberPhone = @"";
        if (user != nil) {
            memeberId = user.memberID;
            memeberPhone = user.memberPhone;
        }
        
        [db executeUpdate:@"insert into GALLERYCUPCAKE(CAKE_G_PID ,ICING_G_PID ,TOPPING_G_PID ,STUFFING_G_PID,type,memeberId,memeberPhone,flavor_pid,name,cakeType,cakePrice,creator,lookOverPicAddress,cutoverpicaddress,isSendPublicGallery,createTime,updateTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         @"1",
         memeberId,
         memeberPhone,
         @"",
         item.cakeName,
         item.cakeType,
         @"",
         item.creator,
         @"",
         @"",
         cupcake.isSendPublicGallery,
        [[NSDate date] getCurrentTime],
        [[NSDate date] getCurrentTime]
    ];

    }else if([@"2" isEqualToString:item.type]) {
        FlavorCupcake *flavorCupcake = item.flavorCupcake;
        CupCake *cupcake = flavorCupcake.cupcake;
        
        NSString *toppingPid = [self getToppingPid:cupcake];
        NSString *stuffingPid = [self getStuffingPid:cupcake];
        
        NSString *memeberId = @"";
        NSString *memeberPhone = @"";
        if (user != nil) {
            memeberId = user.memberID;
            memeberPhone = user.memberPhone;
        }
        
       [db executeUpdate:@"insert into GALLERYCUPCAKE(CAKE_G_PID ,ICING_G_PID ,TOPPING_G_PID ,STUFFING_G_PID,type,memeberId,memeberPhone,flavor_pid,name,cakeType,cakePrice,creator,lookOverPicAddress,cutoverpicaddress,isSendPublicGallery,createTime,updateTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         @"2",
         memeberId,
         memeberPhone,
         flavorCupcake.productID,
         item.cakeName,
         item.cakeType,
         @"",
         item.creator,
         @"",
         @"",
         item.isSendPublicGallery,
         [[NSDate date] getCurrentTime],
         [[NSDate date] getCurrentTime]
         ];
 
    }else if([@"3" isEqualToString:item.type]) {
        FlavorProduct *flavorProduct = item.flavorProduct;

        NSString *memeberId = @"";
        NSString *memeberPhone = @"";
        if (user != nil) {
            memeberId = user.memberID;
            memeberPhone = user.memberPhone;
        }
        
        [db executeUpdate:@"insert into GALLERYCUPCAKE(CAKE_G_PID ,ICING_G_PID ,TOPPING_G_PID ,STUFFING_G_PID,type,memeberId,memeberPhone,flavor_pid,name,cakeType,cakePrice,creator,lookOverPicAddress,cutoverpicaddress,isSendPublicGallery,createTime,updateTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
         @"",
         @"",
         @"",
         @"",
         @"3",
         memeberId,
         memeberPhone,
         flavorProduct.productID,
         item.cakeName,
         item.cakeType,
         @"",
         item.creator,
         @"",
         @"",
         item.isSendPublicGallery,
         [[NSDate date] getCurrentTime],
         [[NSDate date] getCurrentTime]
         ];

    }
    
    [db commit];
    [db close];
}

#pragma mark 更新收藏
- (void)updateGalleryCupcake:(GalleryItem *)item {

    if (![db open]) {
        return;
    }
    
    if (item == nil) {
        return;
    }

    NSString *executeStr = @"update GALLERYCUPCAKE set name = ? ,creator  = ?, isSendPublicGallery = ?  where CAKE_G_PID = ?  and ICING_G_PID = ? and TOPPING_G_PID = ? and STUFFING_G_PID = ? and flavor_pid = ?";
    NSString *type = item.type;
    
    if ([@"1" isEqualToString:type]) {
        CupCake *cupcake = item.cupcake;
        
        NSString *toppingPid = [self getToppingPid:cupcake];
        NSString *stuffingPid = [self getStuffingPid:cupcake];
        [db beginTransaction];
        [db executeUpdate:executeStr,
         item.cakeName,
         item.creator,
         item.isSendPublicGallery,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         @""
         ];
    }else if ([@"2" isEqualToString:type]) {
        FlavorCupcake *flavorCupcake = item.flavorCupcake;
        CupCake *cupcake = flavorCupcake.cupcake;
        
        NSString *toppingPid = [self getToppingPid:cupcake];
        NSString *stuffingPid = [self getStuffingPid:cupcake];
        
        [db beginTransaction];
        [db executeUpdate:executeStr,
         item.cakeName,
         item.creator,
         item.isSendPublicGallery,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         flavorCupcake.productID
         ];
    }else if ([@"3" isEqualToString:type]) {
        FlavorProduct *product = item.flavorProduct;
        [db beginTransaction];
        [db executeUpdate:executeStr,
         item.cakeName,
         item.creator,
         item.isSendPublicGallery,
         @"",
         @"",
         @"",
         @"",
         product.productID
         ];
    }
    

    [db commit];
    [db close];
}

#pragma mark 删除收藏
- (void)delGalleryCupcake:(GalleryItem *)item {
    
    if (![db open]) {
        return;
    }
    
    if (item == nil) {
        return;
    }
    
    NSString *type = item.type;
    if ([@"1" isEqualToString:type]) {
        CupCake *cupcake = item.cupcake;
        
        NSString *toppingPid = [self getToppingPid:cupcake];
        NSString *stuffingPid = [self getStuffingPid:cupcake];
        [db beginTransaction];
        NSString *executeStr = @"delete from GALLERYCUPCAKE where CAKE_G_PID = ?  and ICING_G_PID = ? and TOPPING_G_PID = ? and STUFFING_G_PID = ? and flavor_pid = ?";
        [db executeUpdate:executeStr,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         @""
         ];
    }else if ([@"2" isEqualToString:type]) {
        FlavorCupcake *flavorCupcake = item.flavorCupcake;
        CupCake *cupcake = flavorCupcake.cupcake;
        NSString *toppingPid = [self getToppingPid:cupcake];
        NSString *stuffingPid = [self getStuffingPid:cupcake];
        
        [db beginTransaction];
        NSString *executeStr = @"delete from GALLERYCUPCAKE where CAKE_G_PID = ?  and ICING_G_PID = ? and TOPPING_G_PID = ? and STUFFING_G_PID = ? and flavor_pid = ?";
        [db executeUpdate:executeStr,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         flavorCupcake.productID
         ];
        
        
    }else if ([@"3" isEqualToString:type]) {
        FlavorProduct *flavorProduct = item.flavorProduct;
        [db beginTransaction];
        NSString *executeStr = @"delete from GALLERYCUPCAKE where flavor_pid = ?";
        [db executeUpdate:executeStr,
         flavorProduct.productID
         ];
    }

    [db commit];
    [db close];
}

#pragma mark 查询收藏夹数量
- (NSInteger)getGalleryCupcakeNum {
    if (![db open]) {
        return 0;
    }
    
    
    NSString *queryStr = [NSString stringWithFormat:@"select count(*) from GALLERYCUPCAKE"];
    NSUInteger count = [db intForQuery:queryStr];
    [db close];
    return count;
}

#pragma mark 获取收藏夹列表NSMutableArray
- (NSMutableArray *)retrieveGalleryCupcake {
    NSMutableArray *cupcakes = [[NSMutableArray alloc] init];
    
    if (![db open]) {
        return cupcakes;
    }


    NSString *queryStr = [NSString stringWithFormat:@"select * from GALLERYCUPCAKE"];
    
    FMResultSet *rs = [db executeQuery:queryStr];
    while ([rs next]) {
        
        NSString *type = [rs stringForColumn:@"type"];

        if ([@"1" isEqualToString:type]) {
            
            NSString *cakePid = [rs stringForColumn:@"CAKE_G_PID"];
            NSString *icingPid = [rs stringForColumn:@"ICING_G_PID"];
            NSString *toppingPid = [rs stringForColumn:@"TOPPING_G_PID"];
            NSString *stuffingPid = [rs stringForColumn:@"STUFFING_G_PID"];
            
            Cake *cake = [self queryCakeTalbe:cakePid];
            Icing *icing = [self queryIcingTalbe:icingPid];
            Topping *topping = [self queryToppingTalbe:toppingPid];
            Stuffing *stuffing = [self queryStuffingTalbe:stuffingPid];
            
            CupCake *ret = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
            GalleryItem *item = [[GalleryItem alloc] initWithCupcake:ret];
            item.memeberId = [rs stringForColumn:@"memeberId"];
            item.memeberPhone = [rs stringForColumn:@"memeberPhone"];
//            item.flavor_pid = [rs stringForColumn:@"flavor_pid"];
            item.creator = [rs stringForColumn:@"CREATOR"];
            item.cakeName = [rs stringForColumn:@"NAME"];
            item.cakeType = [rs stringForColumn:@"CAKETYPE"];
            [cupcakes addObject:item];
        }else if([@"2" isEqualToString:type]) {
            NSString *cakePid = [rs stringForColumn:@"CAKE_G_PID"];
            NSString *icingPid = [rs stringForColumn:@"ICING_G_PID"];
            NSString *toppingPid = [rs stringForColumn:@"TOPPING_G_PID"];
            NSString *stuffingPid = [rs stringForColumn:@"STUFFING_G_PID"];
            
            Cake *cake = [self queryCakeTalbe:cakePid];
            Icing *icing = [self queryIcingTalbe:icingPid];
            Topping *topping = [self queryToppingTalbe:toppingPid];
            Stuffing *stuffing = [self queryStuffingTalbe:stuffingPid];
            FlavorCupcake *flavorCupcake = [[FlavorCupcake alloc] init];
            
            flavorCupcake.cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
            GalleryItem *item = [[GalleryItem alloc] initWithFlavorCupcake:flavorCupcake];
            item.memeberId = [rs stringForColumn:@"memeberId"];
            item.memeberPhone = [rs stringForColumn:@"memeberPhone"];
//            item.flavor_pid = [rs stringForColumn:@"flavor_pid"];
            item.creator = [rs stringForColumn:@"CREATOR"];
            item.cakeName = [rs stringForColumn:@"NAME"];
            item.cakeType = [rs stringForColumn:@"CAKETYPE"];
            [cupcakes addObject:item];
        }else if([@"3" isEqualToString:type]){
            
            NSString *flaovrId = [rs stringForColumn:@"flavor_pid"];
            FlavorProduct *flavorProduct = [self queryShoppingCartFlaovrProduct:flaovrId];
            if (flavorProduct != nil) {
                GalleryItem *item = [[GalleryItem alloc] initWithFlavorProduct:flavorProduct];
                item.memeberId = [rs stringForColumn:@"memeberId"];
                item.memeberPhone = [rs stringForColumn:@"memeberPhone"];
                item.creator = [rs stringForColumn:@"CREATOR"];
                item.cakeName = [rs stringForColumn:@"NAME"];
                item.cakeType = [rs stringForColumn:@"CAKETYPE"];
                [cupcakes addObject:item];
            }
            
        }
        
        
    }
    
    [db close];

    return cupcakes;
}


- (FlavorProduct *)queryShoppingCartFlaovrProduct:(NSString *)pid {
    if (![db open]) {
        return nil;
    }
    NSString *queryStr = @"select * from FlavorProduct where productID = ? ";
    FMResultSet *rs = [db executeQuery:queryStr,pid];
    if ([rs next]) {
        
        NSDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[rs stringForColumn:@"productID"] forKey:@"productID"];
        [dic setValue:[rs stringForColumn:@"productName"] forKey:@"productName"];
        [dic setValue:[rs stringForColumn:@"productPrice"] forKey:@"productPrice"];
        [dic setValue:[rs stringForColumn:@"productTime"] forKey:@"productTime"];
        [dic setValue:[rs stringForColumn:@"productKind"] forKey:@"productKind"];
        [dic setValue:[rs stringForColumn:@"productType"] forKey:@"productType"];
        [dic setValue:[rs stringForColumn:@"productState"] forKey:@"productState"];
        [dic setValue:[rs stringForColumn:@"productDes"] forKey:@"productDes"];
        [dic setValue:[rs stringForColumn:@"cutPic"] forKey:@"cutPic"];
        [dic setValue:[rs stringForColumn:@"overServerPic"] forKey:@"overPic"];
        [dic setValue:[rs stringForColumn:@"ppBackgroundServerPic"] forKey:@"ppBackgroundServerPic"];
        [dic setValue:[rs stringForColumn:@"ppBackgroundPic"] forKey:@"ppBackgroundPic"];
        [dic setValue:[rs stringForColumn:@"updateTime"] forKey:@"updateTime"];
        FlavorProduct *product = [[FlavorProduct alloc] initWithDic:dic];
        return product;
        
    }

    return nil;
}

- (void)insertShoppingCartFlaovrProduct:(FlavorProduct *)product {
    if (![db open]) {
        return;
    }
    
    [db beginTransaction];
    [db executeUpdate:@"insert into FlavorProduct(productID,productName,productPrice,productTime,productKind,productType,productState,productDes,cutPic,overPic,overServerPic,ppBackgroundPic,ppBackgroundServerPic,updateTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
     product.productID,
     product.productName,
     product.productPrice,
     product.productTime,
     product.productKind,
     product.productType,
     product.productState,
     product.productDes,
     product.cutPic,
     product.overPic,
     product.overServerPic,
     product.ppBackgroundPic,
     product.ppBackgroundServerPic,
     product.updateTime
     ];

    [db commit];
}

#pragma mark 查询喜爱蛋糕
- (FlavorCupcake *)queryShoppingCartFlaovrCupcake:(NSString *)pid {
    if (![db open]) {
        return nil;
    }
    NSString *queryStr = @"select * from FlavorProduct where productID = ? ";
    FMResultSet *rs = [db executeQuery:queryStr,pid];
    if ([rs next]) {
        FlavorCupcake *flavorCupcake = [[FlavorCupcake alloc] init];
        flavorCupcake.productID = pid;
        flavorCupcake.productName = [rs stringForColumn:@"productName"];
        flavorCupcake.productKind = [rs stringForColumn:@"productKind"];
        flavorCupcake.productType = [rs stringForColumn:@"productType"];
        flavorCupcake.productState = [rs stringForColumn:@"productState"];
        flavorCupcake.productDes = [rs stringForColumn:@"productDes"];
        flavorCupcake.productCake = [rs stringForColumn:@"cakePid"];
        flavorCupcake.productIcing = [rs stringForColumn:@"icingPid"];
        flavorCupcake.productTopping = [rs stringForColumn:@"toppingPid"];
        flavorCupcake.productStuffing = [rs stringForColumn:@"stuffingPid"];
        flavorCupcake.updateTime = [rs stringForColumn:@"updateTime"];
        return flavorCupcake;
    }
    
    return nil;
}

#pragma mark 保存喜爱蛋糕
- (void)insertShoppingCartFlaovrCupcake:(FlavorCupcake *)flavorCupcake {
    if (![db open]) {
        return;
    }
    
    [db beginTransaction];
    [db executeUpdate:@"insert into FlavorProduct(productID,productName,productKind,productType,productState,cakePid,icingPid,toppingPid,stuffingPid,updateTime) values(?,?,?,?,?,?,?,?,?,?)",
     flavorCupcake.productID,
     flavorCupcake.productName,
     flavorCupcake.productKind,
     flavorCupcake.productType,
     flavorCupcake.productState,
     flavorCupcake.productCake,
     flavorCupcake.productIcing,
     flavorCupcake.productTopping,
     flavorCupcake.productStuffing,
     flavorCupcake.updateTime
     ];

    [db commit];
}

#pragma mark 更新喜爱蛋糕
- (void)updateShoppingCartFlaovrCupcake:(FlavorCupcake *)flaovrCupcake {
    if (![db open]) {
        return;
    }
    
    NSString *executeStr = @"update FlavorProduct set productName = ? , productKind = ? , productType = ? , productState = ?,  cakePid = ? , icingPid = ? , toppingPid = ? ,stuffingPid = ?, updateTime = ? where productID = ?";
    
    [db beginTransaction];
    [db executeUpdate:executeStr,
     flaovrCupcake.productName,
     flaovrCupcake.productKind,
     flaovrCupcake.productType,
     flaovrCupcake.productState,
     flaovrCupcake.productCake,
     flaovrCupcake.productIcing,
     flaovrCupcake.productTopping,
     flaovrCupcake.productStuffing,
     flaovrCupcake.updateTime,
     flaovrCupcake.productID
     ];
    
    [db commit];

}

#pragma mark 更新喜爱产品
- (void)updateShoppingCartFlaovrProduct:(FlavorProduct *)product {
    if (![db open]) {
        return;
    }
    
    NSString *executeStr = @"update FlavorProduct set productName = ? ,productPrice = ? , productKind = ? , productType = ? , productState = ? , productDes = ? , cutPic = ? , overPic = ? , overServerPic = ? , ppBackgroundPic = ? , ppBackgroundServerPic = ? , updateTime = ? where productID = ? ";

    [db beginTransaction];
    [db executeUpdate:executeStr,
     product.productName,
     product.productPrice,
     product.productKind,
     product.productType,
     product.productState,
     product.productDes,
     product.cutPic,
     product.overPic,
     product.overServerPic,
     product.ppBackgroundPic,
     product.ppBackgroundServerPic,
     product.updateTime,
     product.productID
    ];
    
    [db commit];

    
}

#pragma mark 保存购物车
- (void)insertShoppingCart:(OrderCupcake *)orderCupcake loginUser:(UserInfo *)user {
    if (![db open]) {
        return;
    }
    
    if (orderCupcake == nil) {
        return;
    }
    
    OrderCupcake *queryOrderCupcake = [self getShoppingCartOrderCupcake:orderCupcake user:user];
    
    if (queryOrderCupcake != nil) {
        //更新数量
        [self updateShoppingCartSameItem:queryOrderCupcake addNum:orderCupcake.num loginUser:user];
        
    }else{
        //插入数据
        if ([@"1" isEqualToString:orderCupcake.type]) {
            CupCake *cupcake = orderCupcake.cupcake;
            NSString *toppingPid = @"-1";
            if (cupcake.topping) {
                toppingPid = cupcake.topping.pid;
            }
            
            NSString *stuffingPid = @"-1";
            if (cupcake.stuffing) {
                stuffingPid = cupcake.stuffing.pid;
            }
            
            [db open];
            [db beginTransaction];
            [db executeUpdate:@"insert into SHOPPINGCART(MEMEBERID,MEMEBERPHONE,TYPE,CAKEPID,ICINGPID,TOPPINGPID,STUFFINGPID,CREATETIME,UPDATETIME,PRODUCT_NUM,PRODUCT_DISPLAY_PIC_NAME,FLAVOR_PID) values(?,?,?,?,?,?,?,?,?,?,?,?)",
             user.memberID,
             user.memberPhone,
             orderCupcake.type,
             cupcake.cake.pid,
             cupcake.icing.pid,
             toppingPid,
             stuffingPid,
             [[NSDate date] getCurrentTime],
             [[NSDate date] getCurrentTime],
             [NSString stringWithFormat:@"%lu",(unsigned long)orderCupcake.num],
             @"",
             @""
             ];
            
        }else if ([@"2" isEqualToString:orderCupcake.type]) {
            FlavorCupcake *flavorCupcake = orderCupcake.flavorCupcake;
            CupCake *cupcake = flavorCupcake.cupcake;
            
            FlavorCupcake *query = [self queryShoppingCartFlaovrCupcake:flavorCupcake.productID];
            if (query == nil) {
                [self insertShoppingCartFlaovrCupcake:flavorCupcake];
            }else{
                [self updateShoppingCartFlaovrCupcake:flavorCupcake];
            }
            
            NSString *toppingPid = @"-1";
            if (cupcake.topping) {
                toppingPid = cupcake.topping.pid;
            }
            
            NSString *stuffingPid = @"-1";
            if (cupcake.stuffing) {
                stuffingPid = cupcake.stuffing.pid;
            }
            
            [db beginTransaction];
            [db executeUpdate:@"insert into SHOPPINGCART(MEMEBERID,MEMEBERPHONE,TYPE,CAKEPID,ICINGPID,TOPPINGPID,STUFFINGPID,CREATETIME,UPDATETIME,PRODUCT_NUM,PRODUCT_DISPLAY_PIC_NAME,FLAVOR_PID) values(?,?,?,?,?,?,?,?,?,?,?,?)",
             user.memberID,
             user.memberPhone,
             orderCupcake.type,
             cupcake.cake.pid,
             cupcake.icing.pid,
             toppingPid,
             stuffingPid,
             [[NSDate date] getCurrentTime],
             [[NSDate date] getCurrentTime],
             [NSString stringWithFormat:@"%lu",(unsigned long)orderCupcake.num],
             @"",
             flavorCupcake.productID
             ];
            
        }else if ([@"3" isEqualToString:orderCupcake.type]) {
            FlavorProduct *product = orderCupcake.flavorProduct;
            
            FlavorProduct *query = [self queryShoppingCartFlaovrProduct:product.productID];
            if (query == nil) {
                [self insertShoppingCartFlaovrProduct:product];
            }else{
                [self updateShoppingCartFlaovrProduct:product];
            }
            
            [db open];
            [db beginTransaction];
            [db executeUpdate:@"insert into SHOPPINGCART(MEMEBERID,MEMEBERPHONE,TYPE,CREATETIME,UPDATETIME,PRODUCT_NUM,FLAVOR_PID) values(?,?,?,?,?,?,?)",
             user.memberID,
             user.memberPhone,
             orderCupcake.type,
             [[NSDate date] getCurrentTime],
             [[NSDate date] getCurrentTime],
             [NSString stringWithFormat:@"%lu",(unsigned long)orderCupcake.num],
             product.productID
             ];
        }
    }
    
    [db commit];
    [db close];
}

#pragma mark 更新购物车
- (void)updateShoppingCart:(OrderCupcake *)orderCupcake loginUser:(UserInfo *)user {
    
    if (![db open]) {
        return;
    }
    
    CupCake *cupcake = orderCupcake.cupcake;
    
    NSMutableString *executeStr = [[NSMutableString alloc] init];
    
    if ([@"1" isEqualToString:orderCupcake.type] || [@"1" isEqualToString:orderCupcake.type]) {
        [executeStr appendString:@"update SHOPPINGCART set PRODUCT_NUM = ? ,UPDATETIME  = ? "];
        [executeStr appendString:@" where MEMEBERID = ?  and MEMEBERPHONE = ? and CAKEPID = ? and ICINGPID = ? and TOPPINGPID = ? and STUFFINGPID = ? "];
        
        NSString *toppingPid = @"-1";
        if (cupcake.topping) {
            toppingPid = cupcake.topping.pid;
        }
        
        NSString *stuffingPid = @"-1";
        if (cupcake.stuffing) {
            stuffingPid = cupcake.stuffing.pid;
        }
        
        [db beginTransaction];
        [db executeUpdate:executeStr,
         orderCupcake.num,
         [[NSDate date] getCurrentTime],
         user.memberID,
         user.memberPhone,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid];
    }else{
        LOG(@"flaovr product update");
    }
    
    [db commit];
    [db close];
}

#pragma mark 更新购物车数量
- (void)updateShoppingCartSameItem:(OrderCupcake *)orderCupcake addNum:(NSInteger)num loginUser:(UserInfo *)user {
    
    if (![db open]) {
        return;
    }
    
    if ([@"1" isEqualToString:orderCupcake.type]) {
        CupCake *cupcake = orderCupcake.cupcake;
        
        NSMutableString *executeStr = [[NSMutableString alloc] init];
        [executeStr appendString:@"update SHOPPINGCART set PRODUCT_NUM = ? "];
        [executeStr appendString:@" where MEMEBERID = ?  and MEMEBERPHONE = ? and CAKEPID = ? and ICINGPID = ? and TOPPINGPID = ? and STUFFINGPID =  ?"];
        
        NSString *toppingPid = @"-1";
        if (cupcake.topping) {
            toppingPid = cupcake.topping.pid;
        }
        
        NSString *stuffingPid = @"-1";
        if (cupcake.stuffing) {
            stuffingPid = cupcake.stuffing.pid;
        }
        
        [db beginTransaction];
        [db executeUpdate:executeStr,
         [NSString stringWithFormat:@"%lu", orderCupcake.num + num],
         user.memberID,
         user.memberPhone,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid
         ];
    }else if([@"2" isEqualToString:orderCupcake.type]){
        
        FlavorCupcake *flaoverCupcake = orderCupcake.flavorCupcake;
        CupCake *cupcake = flaoverCupcake.cupcake;
        
        NSMutableString *executeStr = [[NSMutableString alloc] init];
        [executeStr appendString:@"update SHOPPINGCART set PRODUCT_NUM = ? "];
        [executeStr appendString:@" where MEMEBERID = ?  and MEMEBERPHONE = ? and CAKEPID = ? and ICINGPID = ? and TOPPINGPID = ? and STUFFINGPID =  ? and FLAVOR_PID = ? "];
        
        NSString *toppingPid = @"-1";
        if (cupcake.topping) {
            toppingPid = cupcake.topping.pid;
        }
        
        NSString *stuffingPid = @"-1";
        if (cupcake.stuffing) {
            stuffingPid = cupcake.stuffing.pid;
        }
        
        [db beginTransaction];
        [db executeUpdate:executeStr,
         [NSString stringWithFormat:@"%lu", orderCupcake.num + num],
         user.memberID,
         user.memberPhone,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         flaoverCupcake.productID
         ];

    }else if([@"3" isEqualToString:orderCupcake.type]){
        
        FlavorProduct *product = orderCupcake.flavorProduct;
        NSString *executeStr = @"update SHOPPINGCART set PRODUCT_NUM = ? where MEMEBERID = ?  and MEMEBERPHONE = ? and FLAVOR_PID = ? ";
        
        [db beginTransaction];
        [db executeUpdate:executeStr,
         [NSString stringWithFormat:@"%lu", orderCupcake.num + num],
         user.memberID,
         user.memberPhone,
         product.productID
         ];
    }

    [db commit];
    [db close];
}


#pragma mark 删除购物车
- (void)delShoppingCart:(OrderCupcake *)orderCupcake loginUser:(UserInfo *)user{
    
    if (![db open]) {
        return;
    }
    
    NSString *type = orderCupcake.type;
    NSMutableString *executeStr = [[NSMutableString alloc] init];
    
    if ([@"1" isEqualToString:type]) {
        
        CupCake *cupcake = orderCupcake.cupcake;
        
        [executeStr appendString:@"delete from SHOPPINGCART where CAKEPID = ?  and ICINGPID = ? and TOPPINGPID = ? and STUFFINGPID = ? and MEMEBERID = ? and MEMEBERPHONE = ?"];
        
        
        NSString *toppingPid = @"-1";
        if (cupcake.topping) {
            toppingPid = cupcake.topping.pid;
        }
        
        NSString *stuffingPid = @"-1";
        if (cupcake.stuffing) {
            stuffingPid = cupcake.stuffing.pid;
        }
        
        [db beginTransaction];
        [db executeUpdate:executeStr,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         user.memberID,
         user.memberPhone
         ];
    }else if([@"2" isEqualToString:type]) {
        FlavorCupcake *flavorCupcake = orderCupcake.flavorCupcake;
        NSString *executeDelCart = @"delete from SHOPPINGCART where FLAVOR_PID = ? and MEMEBERID = ? and MEMEBERPHONE = ?";
        
        [db beginTransaction];
        [db executeUpdate:executeDelCart,flavorCupcake.productID,user.memberID,user.memberPhone];


    }else if([@"3" isEqualToString:type]) {
        FlavorProduct *flavorProduct = orderCupcake.flavorProduct;
        NSString *executeDelCart = @"delete from SHOPPINGCART where FLAVOR_PID = ? and MEMEBERID = ? and MEMEBERPHONE = ?";
        
        [db beginTransaction];
        [db executeUpdate:executeDelCart,flavorProduct.productID,user.memberID,user.memberPhone];
    }
    
    [db commit];
    [db close];
}


#pragma mark 查询购物车数量
- (NSInteger)getShoppingCartNum:(UserInfo *)user {
    if (![db open]) {
        return 0;
    }

    NSString *queryStr = [NSString stringWithFormat:@"select count(*) from SHOPPINGCART where MEMEBERID = ? and MEMEBERPHONE = ?"];
    NSUInteger count = [db intForQuery:queryStr,user.memberID,user.memberPhone];
    [db close];
    return count;
}

#pragma mark 查询购物车订单合并
- (OrderCupcake *)getShoppingCartOrderCupcake:(OrderCupcake *)orderCupcake user:(UserInfo *)user {
    if (![db open]) {
        return 0;
    }
    
    NSString *type = orderCupcake.type;
    
    if ([@"1" isEqualToString:type]) {
        
        CupCake *cupcake = orderCupcake.cupcake;
        
        NSString *queryStr = [NSString stringWithFormat:@"select * from SHOPPINGCART where MEMEBERID = ? and MEMEBERPHONE = ? and CAKEPID = ? and ICINGPID = ? and TOPPINGPID = ? and STUFFINGPID = ?"];
        
        NSString *toppingPid = @"-1";
        if (cupcake.topping) {
            toppingPid = cupcake.topping.pid;
        }
        
        NSString *stuffingPid = @"-1";
        if (cupcake.stuffing) {
            stuffingPid = cupcake.stuffing.pid;
        }
        
        FMResultSet *rs = [db executeQuery:queryStr,
         user.memberID,
         user.memberPhone,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid
         ];
        
        if ([rs next]) {
            NSString *cakePid = [rs stringForColumn:@"CAKEPID"];
            NSString *icingPid = [rs stringForColumn:@"ICINGPID"];
            NSString *toppingPid = [rs stringForColumn:@"TOPPINGPID"];
            NSString *stuffingPid = [rs stringForColumn:@"STUFFINGPID"];
            
            Cake *cake = (Cake *)[self queryCakeTalbe:cakePid];
            Icing *icing = (Icing *)[self queryIcingTalbe:icingPid];
            Topping *topping = (Topping *)[self queryToppingTalbe: toppingPid];
            Stuffing *stuffing = (Stuffing *)[self queryStuffingTalbe:stuffingPid];
            
            
            CupCake *cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
            
            NSString *num = [rs stringForColumn:@"PRODUCT_NUM"];
            
            OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithCupcake:cupcake cupcakeNum:[num integerValue]];
            return orderCupcake;
        }
        
        
    }else if ([@"2" isEqualToString:type]) {
        FlavorCupcake *flavorCupcake = orderCupcake.flavorCupcake;
        CupCake *cupcake = flavorCupcake.cupcake;
        
        NSString *queryStr = [NSString stringWithFormat:@"select * from SHOPPINGCART where MEMEBERID = ? and MEMEBERPHONE = ? and CAKEPID = ? and ICINGPID = ? and TOPPINGPID = ? and STUFFINGPID = ? and FLAVOR_PID = ?"];
        
        NSString *toppingPid = @"-1";
        if (cupcake.topping) {
            toppingPid = cupcake.topping.pid;
        }
        
        NSString *stuffingPid = @"-1";
        if (cupcake.stuffing) {
            stuffingPid = cupcake.stuffing.pid;
        }
        
        FMResultSet *rs = [db executeQuery:queryStr,
         user.memberID,
         user.memberPhone,
         cupcake.cake.pid,
         cupcake.icing.pid,
         toppingPid,
         stuffingPid,
         flavorCupcake.productID
         ];
        
        if ([rs next]) {
            NSString *cakePid = [rs stringForColumn:@"CAKEPID"];
            NSString *icingPid = [rs stringForColumn:@"ICINGPID"];
            NSString *toppingPid = [rs stringForColumn:@"TOPPINGPID"];
            NSString *stuffingPid = [rs stringForColumn:@"STUFFINGPID"];
            
            Cake *cake = (Cake *)[self queryCakeTalbe:cakePid];
            Icing *icing = (Icing *)[self queryIcingTalbe:icingPid];
            Topping *topping = (Topping *)[self queryToppingTalbe: toppingPid];
            Stuffing *stuffing = (Stuffing *)[self queryStuffingTalbe:stuffingPid];
            
            
            CupCake *cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
            
            NSString *num = [rs stringForColumn:@"PRODUCT_NUM"];
            
            FlavorCupcake *retFlavorCupcake = [[FlavorCupcake alloc] init];
            retFlavorCupcake.cupcake = cupcake;
            retFlavorCupcake.productType = flavorCupcake.productType;
            retFlavorCupcake.cutPic = flavorCupcake.cutPic;
            retFlavorCupcake.overPic = flavorCupcake.overPic;
            retFlavorCupcake.productPrice = flavorCupcake.productPrice;
            retFlavorCupcake.productName = flavorCupcake.productName;
            retFlavorCupcake.productID = flavorCupcake.productID;
            retFlavorCupcake.productKind = flavorCupcake.productKind;
            retFlavorCupcake.productType = flavorCupcake.productType;
            retFlavorCupcake.productState = flavorCupcake.productState;
            
            OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithFlavorCupcake:retFlavorCupcake cupcakeNum:[num integerValue]];
            return orderCupcake;
        }
        return nil;
        
    }else if ([@"3" isEqualToString:type]) {
        FlavorProduct *flavorProduct = orderCupcake.flavorProduct;
        NSString *queryStr = [NSString stringWithFormat:@"select * from SHOPPINGCART where MEMEBERID = ? and MEMEBERPHONE = ?  and FLAVOR_PID = ?"];
        
        FMResultSet *rs = [db executeQuery:queryStr,
                           user.memberID,
                           user.memberPhone,
                           flavorProduct.productID
                           ];
        
        if ([rs next]) {
            NSString *productId = [rs stringForColumn:@"FLAVOR_PID"];
            NSString *num = [rs stringForColumn:@"PRODUCT_NUM"];
            FlavorProduct *product = [self queryShoppingCartFlaovrProduct:productId];
            OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithFlavorProduct:product cupcakeNum:[num integerValue]];
            return orderCupcake;
        }
    }
    
    return nil;
    
}

#pragma mark 获取购物车列表NSMutableArray
- (NSMutableArray *)retrieveShoppingcart:(UserInfo *)user  {
    NSMutableArray *orderCupcakes = [[NSMutableArray alloc] init];
    
    if (![db open]) {
        return orderCupcakes;
    }
    
    
    NSString *queryStr = [NSString stringWithFormat:@"select * from SHOPPINGCART where MEMEBERID = ? and MEMEBERPHONE = ? "];
    
    FMResultSet *rs = [db executeQuery:queryStr,user.memberID,user.memberPhone];
    while ([rs next]) {

        NSString *type = [rs stringForColumn:@"TYPE"];
        
        LOG(@"========type:[%@]",type);
        if ([@"1" isEqualToString:type]) {
            NSString *cakePid = [rs stringForColumn:@"CAKEPID"];
            NSString *icingPid = [rs stringForColumn:@"ICINGPID"];
            NSString *toppingPid = [rs stringForColumn:@"TOPPINGPID"];
            NSString *stuffingPid = [rs stringForColumn:@"STUFFINGPID"];
            
            Cake *cake = (Cake *)[self queryCakeTalbe:cakePid];
            Icing *icing = (Icing *)[self queryIcingTalbe:icingPid];
            Topping *topping = (Topping *)[self queryToppingTalbe: toppingPid];
            Stuffing *stuffing = (Stuffing *)[self queryStuffingTalbe:stuffingPid];
            
            
            CupCake *cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
            
            NSString *num = [rs stringForColumn:@"PRODUCT_NUM"];
            
            OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithCupcake:cupcake cupcakeNum:[num integerValue]];
            [orderCupcakes addObject:orderCupcake];
            
        }else if([@"2" isEqualToString:type]) {

            NSString *flavorPid = [rs stringForColumn:@"FLAVOR_PID"];
            if (flavorPid != nil) {
                FlavorCupcake *queryFlavorCupcake = [self queryShoppingCartFlaovrCupcake:flavorPid];
                

                
                
                FlavorCupcake *flavorCupcake = [[FlavorCupcake alloc] init];
                
                NSString *cakePid = [rs stringForColumn:@"CAKEPID"];
                NSString *icingPid = [rs stringForColumn:@"ICINGPID"];
                NSString *toppingPid = [rs stringForColumn:@"TOPPINGPID"];
                NSString *stuffingPid = [rs stringForColumn:@"STUFFINGPID"];
                
                Cake *cake = (Cake *)[self queryCakeTalbe:cakePid];
                Icing *icing = (Icing *)[self queryIcingTalbe:icingPid];
                Topping *topping = (Topping *)[self queryToppingTalbe: toppingPid];
                Stuffing *stuffing = (Stuffing *)[self queryStuffingTalbe:stuffingPid];

                CupCake *cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
                
                flavorCupcake.cupcake = cupcake;
                flavorCupcake.productType = queryFlavorCupcake.productType;
                flavorCupcake.productPrice = queryFlavorCupcake.productPrice;
                flavorCupcake.productName = queryFlavorCupcake.productName;
                flavorCupcake.productID = queryFlavorCupcake.productID;
                flavorCupcake.productKind = queryFlavorCupcake.productKind;
                flavorCupcake.productType = queryFlavorCupcake.productType;
                flavorCupcake.productState = queryFlavorCupcake.productState;
                
                NSString *num = [rs stringForColumn:@"PRODUCT_NUM"];
                OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithFlavorCupcake:flavorCupcake cupcakeNum:[num integerValue]];
                [orderCupcakes addObject:orderCupcake];
            }

        }else if([@"3" isEqualToString:type]) {
            NSString *flavorPid = [rs stringForColumn:@"FLAVOR_PID"];
            if (flavorPid != nil) {
                FlavorProduct *product = [self queryShoppingCartFlaovrProduct:flavorPid];
                NSString *num = [rs stringForColumn:@"PRODUCT_NUM"];
                OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithFlavorProduct:product cupcakeNum:[num integerValue]];
                [orderCupcakes addObject:orderCupcake];
            }
        }
    }
    
    [db close];
    
    return orderCupcakes;
}


- (void)updateBasicCake:(BasicCake *)basicCake {
    
    if (![db open]) {
        return;
    }
    
    [db beginTransaction];
    NSString *tableName = [self getTableName:basicCake];
    NSString *executeStr = [NSString stringWithFormat:@"update %@ set MATERIALNAME = ? ,CUTOVERPICNAME = ?,OVERLOOKPICNAME = ?,SELECTPICNAME = ?,MATERIALPRICE=?,UPDATEDATE=?, STATUS = ? , cityIds = ?  where pid = ?",tableName];
    [db executeUpdate:executeStr,
     basicCake.materialName,
     basicCake.cutOverPicName,
     basicCake.overLookPicName,
     basicCake.selectPicName,
     [NSString stringWithFormat:@"%lf",basicCake.materialPrice],
     basicCake.updateDate,
     basicCake.status,
     basicCake.cityIds,
     basicCake.pid];
    
    [db commit];
    [db close];
}

/*
#pragma mark 查询
- (BasicCake *)queryBaiscTalbe_G:(NSString *)tableName pid:(NSString *) pid {
    
    if (![db open]) {
        return nil;
    }
    NSString *queryStr = [NSString stringWithFormat:@"select * from %@ where pid = ?",tableName];
    FMResultSet *rs = [db executeQuery:queryStr,pid];
    if ([rs next]) {
        BasicCake *basicCake = [[BasicCake alloc] init];
        basicCake.pid = [rs stringForColumn:@"PID"];
        basicCake.materialName = [rs stringForColumn:@"MATERIALNAME"];
        basicCake.cutOverPicName = [rs stringForColumn:@"CUTOVERPICNAME"];
        basicCake.cutOverPicServerName = [rs stringForColumn:@"cutOverPicServerName"];
        basicCake.overLookPicName = [rs stringForColumn:@"OVERLOOKPICNAME"];
        basicCake.overLookPicServerName = [rs stringForColumn:@"overLookPicServerName"];
        basicCake.selectPicName = [rs stringForColumn:@"SELECTPICNAME"];
        basicCake.selectPicServerName = [rs stringForColumn:@"selectPicServerName"];
        basicCake.overLookFrontPicName = [rs stringForColumn:@"OVERLOOKFRONTPICNAME"];
        basicCake.overLookFrontPicServerName = [rs stringForColumn:@"overLookFrontPicServerName"];
        basicCake.materialPrice = [[rs stringForColumn:@"MATERIALPRICE"] floatValue];
        basicCake.updateDate = [rs stringForColumn:@"UPDATEDATE"];
        basicCake.status = [rs stringForColumn:@"STATUS"];
        return basicCake;
        
    }
    return nil;
}
*/

#pragma mark 从数据库获取材料信息-封装成BasicCake数组
- (NSMutableArray *)queryBaiscTalbe:(NSString *)tableName materialOnline:(BOOL)online cidId:(NSString *)cid {
    
    if (![db open]) {
        return nil;
    }
    NSString *queryStr = [NSString stringWithFormat:@"select * from %@ ",tableName];
    FMResultSet *rs = [db executeQuery:queryStr,cid];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while ([rs next]) {
        BasicCake *basicCake = [[BasicCake alloc] init];
        basicCake.pid = [rs stringForColumn:@"PID"];
        basicCake.materialName = [rs stringForColumn:@"MATERIALNAME"];
        basicCake.cutOverPicName = [rs stringForColumn:@"CUTOVERPICNAME"];
        basicCake.cutOverPicServerName = [rs stringForColumn:@"cutOverPicServerName"];
        basicCake.overLookPicName = [rs stringForColumn:@"OVERLOOKPICNAME"];
        basicCake.overLookPicServerName = [rs stringForColumn:@"overLookPicServerName"];
        basicCake.overLookFrontPicName = [rs stringForColumn:@"OVERLOOKFRONTPICNAME"];
        basicCake.overLookFrontPicServerName = [rs stringForColumn:@"overLookFrontPicServerName"];
        basicCake.selectPicName = [rs stringForColumn:@"SELECTPICNAME"];
        basicCake.selectPicServerName = [rs stringForColumn:@"selectPicServerName"];
        basicCake.materialPrice = [[rs stringForColumn:@"MATERIALPRICE"] floatValue];
        basicCake.updateDate = [rs stringForColumn:@"UPDATEDATE"];
        basicCake.status = [rs stringForColumn:@"STATUS"];
        basicCake.cityIds = [rs stringForColumn:@"cityIds"];
    

        if (online) {
            if ([@"1" isEqualToString:basicCake.status]) {
                if (cid == nil || [cid length] == 0) {
                    [array addObject:basicCake];
                }else {
                    NSRange range = [basicCake.cityIds rangeOfString:cid];
                    if (range.location != NSNotFound) {
                        [array addObject:basicCake];
                    }
                }
            }
        }else{
            [array addObject:basicCake];
        }
        
    }
    
    
    [db close];
    return array;
}

#pragma mark 查找指定ID的蛋糕
#pragma mark 查询蛋糕组件-材料表
- (Cake *)queryCakeTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"CAKE" pid:pid];
    
    return (bc == nil)? nil : (Cake *)bc;
}

- (Icing *)queryIcingTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"ICING" pid:pid];
    
    return (bc == nil)? nil : (Icing *)bc;
}

- (Topping *)queryToppingTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"TOPPING" pid:pid];
    
    return (bc == nil)? nil : (Topping *)bc;
}

- (Stuffing *)queryStuffingTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"STUFFING" pid:pid];
    
    return (bc == nil)? nil : (Stuffing *)bc;
}

/*
#pragma mark 查询蛋糕组件-收藏夹表
- (Cake *)queryCakeGTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"CAKE_G" pid:pid];
    
    return (bc == nil)? nil : (Cake *)bc;
}

- (Icing *)queryIcingGTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"ICING_G" pid:pid];
    
    return (bc == nil)? nil : (Icing *)bc;
}

- (Topping *)queryToppingGTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"TOPPING_G" pid:pid];
    
    return (bc == nil)? nil : (Topping *)bc;
}

- (Stuffing *)queryStuffingGTalbe:(NSString *)pid {
    BasicCake *bc = [self queryBaiscTalbe:@"STUFFING_G" pid:pid];
    
    return (bc == nil)? nil : (Stuffing *)bc;
}*/

#pragma mark 查找数据实现方法
- (BasicCake *)queryBaiscTalbe:(NSString *)tableName pid:(NSString *) pid {
    
    if (![db open]) {
        return nil;
    }
    
    NSString *queryStr = [NSString stringWithFormat:@"select * from %@ where pid = ?",tableName];
    FMResultSet *rs = [db executeQuery:queryStr,pid];
    if ([rs next]) {
        BasicCake *basicCake = [[BasicCake alloc] init];
        basicCake.pid = [rs stringForColumn:@"PID"];
        basicCake.materialName = [rs stringForColumn:@"MATERIALNAME"];
        basicCake.cutOverPicName = [rs stringForColumn:@"CUTOVERPICNAME"];
        basicCake.cutOverPicServerName = [rs stringForColumn:@"cutOverPicServerName"];
        basicCake.overLookPicName = [rs stringForColumn:@"OVERLOOKPICNAME"];
        basicCake.overLookPicServerName = [rs stringForColumn:@"overLookPicServerName"];
        basicCake.overLookFrontPicName = [rs stringForColumn:@"OVERLOOKFRONTPICNAME"];
        basicCake.overLookFrontPicServerName = [rs stringForColumn:@"overLookFrontPicServerName"];
        basicCake.selectPicName = [rs stringForColumn:@"SELECTPICNAME"];
        basicCake.selectPicServerName = [rs stringForColumn:@"selectPicServerName"];
        basicCake.materialPrice = [[rs stringForColumn:@"MATERIALPRICE"] floatValue];
        basicCake.updateDate = [rs stringForColumn:@"UPDATEDATE"];
        basicCake.status = [rs stringForColumn:@"STATUS"];

        return basicCake;

    }

    return nil;
}

#pragma mark 超时
- (void)hidenLoading {
    [ProgressHUD dismiss];
}

- (void)timeout {
    [self.timeoutTimer invalidate];
    [ProgressHUD dismiss];
    [self performSelector:@selector(timeoutAnimation) withObject:nil afterDelay:1];
}

- (void)timeoutAnimation {
    [ProgressHUD showError:@"服务端正在维护"];
}

- (void)startLoading {
    
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    
    self.timeoutTimer = timer;

}

- (void)finishLoading {
    [self.timeoutTimer invalidate];
}


@end
