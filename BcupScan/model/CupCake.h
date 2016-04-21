//
//  CupCake.h
//  BakeCake
//
//  Created by zhangchong on 8/10/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cake.h"
#import "Icing.h"
#include "Stuffing.h"
#include "Topping.h"

@interface CupCake : NSObject
//蛋糕组成部分
@property (nonatomic, strong) Cake     * cake;
@property (nonatomic, strong) Icing    * icing;
@property (nonatomic, strong) Stuffing * stuffing;
@property (nonatomic, strong) Topping  * topping;
//蛋糕总体介绍
@property (nonatomic, strong) NSString *cakeId;//customID
@property (nonatomic, strong) NSString *cakeName;//customName
@property (nonatomic, strong) NSString *cakeType;
@property (nonatomic, assign) CGFloat  cakePrice;
@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSString *creatorEmail;
@property (nonatomic, strong) NSString *lookoverPicAddress;
@property (nonatomic, strong) NSString *cutoverPicAddress;
@property (nonatomic, assign) NSString *isSendPublicGallery;
//服务接口字段
@property (nonatomic, strong) NSString *customStuffing;
@property (nonatomic, strong) NSString *customCake;
@property (nonatomic, strong) NSString *customTopping;
@property (nonatomic, strong) NSString *customIcing;
@property (nonatomic, strong) NSString *memberPhone;
@property (nonatomic, strong) NSString *updateTime;
- (CupCake *)initWithCake:(Cake*) cake icing:(Icing*) icing stuffing:(Stuffing *) stuffing topping:(Topping *)topping;
- (CupCake *)initWithGalleryDic:(NSDictionary *)dic;
- (CGFloat)getPrice;
@end
