//
//  ProductPackage.m
//  BakeCake
//
//  Created by zhangchong on 10/12/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "ProductPackage.h"
#import "NSDictionary+NoneKeyCheck.h"
#import "FlavorCupcake.h"
#import "FlavorProduct.h"
#import "ResouceManager.h"

@implementation ProductPackage
@synthesize productPackageId;
@synthesize productPackageName;
@synthesize productPackagePic;
@synthesize productPackageServerPic;
@synthesize describe;
@synthesize updateTime;
@synthesize productArray;
@synthesize type;
@synthesize productBackgroudServerPic;
@synthesize productBackgroudPic;

- (ProductPackage *)initWithPackageName:(NSString *)packageName
                            productType:(FLAVOR_PRODUCT_TYPE)ptype
                             packagePic:(NSString *)picName
                               products:(NSMutableArray *)products {
    self = [super init];
    if (self) {
        self.productPackageName = packageName;
        self.type               = ptype;
        self.productPackagePic  = picName;
        self.productArray       = products;
    }
    
    return self;
}

- (ProductPackage *)initWithDic:(NSDictionary *)dic showAll:(BOOL)showAll {
    self = [super init];
    if (self) {
        self.productPackageId          = [dic objectAvoidNullKey:@"kindsID"];
        self.describe                  = [dic objectAvoidNullKey:@"kindsDescribe"];
        self.productPackageName        = [dic objectAvoidNullKey:@"kindsName"];
        self.updateTime                = [dic objectAvoidNullKey:@"updateTime"];
        self.productBackgroudServerPic = [dic objectAvoidNullKey:@"backPic"];
        self.productBackgroudPic       = [[ResouceManager sharedInstance] getFileName:self.productBackgroudServerPic];
        self.productPackageServerPic   = [dic objectAvoidNullKey:@"kindsPic"];
        self.productPackagePic         = [[ResouceManager sharedInstance] getFileName:self.productPackageServerPic];
        self.productArray              = [[NSMutableArray alloc] init];
        NSArray *productInfoArray = [dic objectForKey:@"productInfo"];
        for (NSDictionary *infoDic in productInfoArray) {
            NSString *productType = [infoDic objectAvoidNullKey:@"productType"];

            if ([productType isEqualToString:@"1"]) {
                //喜爱单品
                self.type = PRODUCT_FLAVOR_CLASSIC;
                FlavorCupcake *fcc = [[FlavorCupcake alloc] initWithDic:infoDic];
                
                if (showAll) {
                    [self.productArray addObject:fcc];
                }else{
                    if ([@"1" isEqualToString:fcc.productState]) {
                        [self.productArray addObject:fcc];
                    }else if([@"2" isEqualToString:fcc.productState]) {
                        //下架
                    }
                }
            }else if([productType isEqualToString:@"0"]) {
                //礼盒
                self.type = PRODUCT_PRODUCT;
                FlavorProduct *fp = [[FlavorProduct alloc] initWithDic:infoDic];
                fp.ppBackgroundServerPic = self.productBackgroudServerPic;
                fp.ppBackgroundPic = self.productBackgroudPic;
                
                if (showAll) {
                    [self.productArray addObject:fp];
                }else{
                    if ([@"1" isEqualToString:fp.productState]) {
                        [self.productArray addObject:fp];
                    }else if([@"2" isEqualToString:fp.productState]) {
                        //下架
                    }
                }
            }
        }
        
    }
    
    return self;
}
- (void)addProduct:(Product *)product {
    [self.productArray addObject:product];
}

@end
