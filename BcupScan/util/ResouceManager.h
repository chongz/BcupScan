//
//  ResouceManager.h
//  BakeCake
//
//  Created by zhangchong on 8/20/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FMDatabase;
@class FMDatabaseAdditions;
@class Cake;
@class Icing;
@class Stuffing;
@class Topping;
@class CupCake;
@class OrderCupcake;
@class CustomerAddress;
@class BasicCake;
@class NewOrder;
@class UserInfo;
@class SysConfig;
@class GalleryItem;
@class CityStore;
@class UserLocation;
@class FlavorProduct;
@class FlavorCupcake;
@class DeliveryWay;
@class PickByCustomer;

@interface ResouceManager : NSObject
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSString   *memberID;
@property (nonatomic, strong) NSTimer    *timeoutTimer;
@property (nonatomic, assign) BOOL       isOrderSuccessfull;

- (void)sendUserLocationForBetterService:(UserLocation *)loc;
- (CustomerAddress *)getCustomerAddres;
- (void)saveCustomerAddress:(CustomerAddress *)address;
- (void)resetCustomerAddress;
- (void)resetNewOrder;
- (NewOrder *)getNewOrder;
- (void)saveNewOrder:(NewOrder *)newOrder;
- (void)saveDeliveryWay:(DeliveryWay *)dw;
- (DeliveryWay *)getDeliveryWay;
- (void)resetDeliveryWay;
- (void)downloadPic:(BasicCake *)basicCake;
+ (BOOL)isExistenceNetwork;
+ (BOOL)isExistenceBcupService;
+ (ResouceManager *)sharedInstance;
- (NSString *)getResouceValue:(NSString *)key;
- (NSString *)getFileName:(NSString *)filePathName;
- (void)saveCityStore:(CityStore *)city;
- (CityStore *)getCityStore;
- (void)resetCurrentCity;
- (UserInfo *)getUserInfo;
- (PickByCustomer *)getPickByCustomer;
- (void)savePickByCustomer:(PickByCustomer *)pbc;
- (void)saveUserInfo:(UserInfo *)userInfo;
- (void)setExtraCellLineHidden: (UITableView *)tableView;
- (void)requestArgument:(int)requestTime;
- (void)downloadCupcakeResource:(int)requestTime
                    downloadPic:(BOOL)download
                         showUI:(BOOL)showUI
                           inVC:(UIViewController *)vc
                         pageNo:(NSUInteger)pageNo
                         cityId:(NSString *)cityId
                       pageSize:(NSUInteger)pageSize;
- (void)downloadPic:(NSString *)picName inDiretory:(NSString *)path;
- (void)downloadFlavorProduct;
- (NSString *)getTableName:(BasicCake *)basicCake;
- (BasicCake *)queryBaiscTalbe:(NSString *)tableName pid:(NSString *) pid;
- (void)updateBasicCake:(BasicCake *)basicCake;
- (NSURL *)getServerDownloadPath:(NSString *)remoteFileName;
+ (NSString *)appPath;
+ (NSString *)doucmentPath;
+ (NSString *)libraryPath;
+ (NSString *)chachesPath;
+ (NSString *)tmpPath;
- (NSString *)savePNGImageFromImageView:(UIView *)view filePathName:(NSString *)fileName;
- (void)closeDb;
- (void)initDB;
- (NSMutableArray *)queryBaiscTalbe:(NSString *)tableName materialOnline:(BOOL)online cidId:(NSString *)cid;
- (void)insertBasicCake:(BasicCake *)basicCake;
- (Cake *)queryCakeTalbe:(NSString *)pid ;
- (Icing *)queryIcingTalbe:(NSString *)pid ;
- (Topping *)queryToppingTalbe:(NSString *)pid;
- (Stuffing *)queryStuffingTalbe:(NSString *)pid;
- (NSString *)getToppingPid:(CupCake *)cupcake;
- (NSString *)getStuffingPid:(CupCake *)cupcake;
//可送货城市
- (void)requestDeliverCity;
- (void)updateCity:(CityStore *)store;
- (NSMutableArray *)queryCityStores;
- (NSMutableArray *)queryStoreInCity:(NSString *)cityId;
//收藏夹
- (void)updateGalleryCupcake:(GalleryItem *)item;
- (void)insertGalleryCupcakeOrderCupcake:(GalleryItem *)item user:(UserInfo *)user;
- (void)delGalleryCupcake:(GalleryItem *)item;
- (GalleryItem *)getGalleryItem:(GalleryItem *)searchItem;
- (GalleryItem *)getCupcakeFromGallery:(NSString *)cakePid
                               icingId:(NSString *)icingPid
                             toppingId:(NSString *)toppingPid
                            stuffingId:(NSString *)stuffingPid
                             flaoverId:(NSString *)flavorId
                                userId:(NSString *)userId
                             userPhone:(NSString *)userPhone;
- (NSMutableArray *)retrieveGalleryCupcake;
- (NSInteger)getGalleryCupcakeNum;
- (void)insertGalleryOrderCupcake:(OrderCupcake *)occ user:(UserInfo *)user;
- (FlavorProduct *)queryShoppingCartFlaovrProduct:(NSString *)pid;
- (void)updateShoppingCartFlaovrProduct:(FlavorProduct *)product;
- (void)insertShoppingCartFlaovrProduct:(FlavorProduct *)product;
- (FlavorCupcake *)queryShoppingCartFlaovrCupcake:(NSString *)pid;
- (void)insertShoppingCartFlaovrCupcake:(FlavorCupcake *)flavorCupcake;
- (void)updateShoppingCartFlaovrCupcake:(FlavorCupcake *)flaovrCupcake;
//购物车
- (void)insertShoppingCart:(OrderCupcake *)orderCupcake loginUser:(UserInfo *)user;
- (void)updateShoppingCart:(OrderCupcake *)orderCupcake loginUser:(UserInfo *)user;
- (NSMutableArray *)retrieveShoppingcart:(UserInfo *)user;
- (void)delShoppingCart:(OrderCupcake *)orderCupcake loginUser:(UserInfo *)user;
- (NSInteger)getShoppingCartNum:(UserInfo *)user;
- (SysConfig *)querySysconfig:(NSString *)configId;
- (void)saveUpdateSysconfig:(SysConfig *)config;
- (void)hidenLoading;
- (void)timeout;
- (void)startLoading;
- (void)finishLoading;
@end
