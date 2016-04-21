//
//  ProductPackage.h
//  BakeCake
//
//  Created by zhangchong on 10/12/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Product.h"

@interface ProductPackage : NSObject
@property (nonatomic, strong) NSString            *productPackageId;//kindsID
@property (nonatomic, strong) NSString            *productPackageName;//kindsName
@property (nonatomic, strong) NSString            *productPackagePic;//kindsPic
@property (nonatomic, strong) NSString            *productBackgroudServerPic;
@property (nonatomic, strong) NSString            *productBackgroudPic;
@property (nonatomic, strong) NSString            *productPackageServerPic;//服务端图片地址
@property (nonatomic, strong) NSString            *describe;//kindsDescribe
@property (nonatomic, strong) NSString            *updateTime;//updateTime
@property (nonatomic, strong) NSMutableArray      *productArray;//productInfo
@property (nonatomic, assign) FLAVOR_PRODUCT_TYPE type;

- (ProductPackage *)initWithPackageName:(NSString *)packageName
                            productType:(FLAVOR_PRODUCT_TYPE)ptype
                             packagePic:(NSString *)picName
                               products:(NSMutableArray *)products;

- (ProductPackage *)initWithDic:(NSDictionary *)dic showAll:(BOOL)show;


- (void)addProduct:(Product *)product;
@end
