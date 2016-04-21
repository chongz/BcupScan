//
//  FlavorCupcake.h
//  BakeCake
//
//  Created by zhangchong on 10/19/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cake.h"
#import "Icing.h"
#import "Topping.h"
#import "Stuffing.h"
#import "CupCake.h"

@interface FlavorCupcake : NSObject

@property (nonatomic, strong) CupCake  *cupcake;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *productDes;
@property (nonatomic, strong) NSString *cutPic;
@property (nonatomic, strong) NSString *overPic;
@property (nonatomic, strong) NSString *productPrice;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *productKind;
@property (nonatomic, strong) NSString *productType;
@property (nonatomic, strong) NSString *productState;
@property (nonatomic, strong) NSString *productStuffing;
@property (nonatomic, strong) NSString *productTopping;
@property (nonatomic, strong) NSString *productCake;
@property (nonatomic, strong) NSString *productIcing;
@property (nonatomic, strong) NSString *productTime;

- (FlavorCupcake *)initWithDic:(NSDictionary *)dic;
@end
