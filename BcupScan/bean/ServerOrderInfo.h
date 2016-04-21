//
//  ServerOrderInfo.h
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerAddress.h"
#import "FlavorCupcake.h"
#import "FlavorProduct.h"
#import "CupCake.h"
#import "OrderCupcake.h"

@interface ServerOrderInfo : NSObject
@property (nonatomic, strong) NSString       *orderID;
@property (nonatomic, strong) NSString       *orderState;
@property (nonatomic, strong) NSString       *orderDetails;
@property (nonatomic, strong) NSString       *orderPhone;
@property (nonatomic, strong) NSString       *orderSource;
@property (nonatomic, strong) NSString       *orderSourceText;
@property (nonatomic, strong) NSString       *orderCity;
@property (nonatomic, strong) NSString       *orderBuyer;
@property (nonatomic, strong) NSString       *orderPay;
@property (nonatomic, strong) NSString       *orderPayText;
@property (nonatomic, strong) NSString       *orderAddress;
@property (nonatomic, strong) NSString       *timeDelivery;
@property (nonatomic, strong) NSString       *timeStart;
@property (nonatomic, strong) NSString       *orderDeliveryMethod;
@property (nonatomic, strong) NSString       *orderDeliveryFee;
@property (nonatomic, strong) NSString       *postCardID;
@property (nonatomic, strong) NSString       *postCardContent;
@property (nonatomic, strong) NSString       *orderPin;
@property (nonatomic, strong) NSString       *orderKind;
@property (nonatomic, strong) NSString       *orderStore;
@property (nonatomic, strong) NSMutableArray *orderAssessArray;
@property (nonatomic, strong) NSMutableArray *orderArray;

- (ServerOrderInfo *)initWithDic:(NSDictionary *)dic;
- (NSInteger)getProductNum;
- (CGFloat)getPrice;
- (BOOL)isEvalue;
- (BOOL)isPickByUser;
@end
