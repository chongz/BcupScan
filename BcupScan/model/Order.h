//
//  Order.h
//  BakeCake
//
//  Created by zhangchong on 9/22/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "CupCake.h"
#import "OrderCupcake.h"

@interface Order : NSObject
@property (nonatomic, strong) NSString       *orderId;
@property (nonatomic, assign) ORDER_STATUS   orderStatus;
@property (nonatomic, strong) NSMutableArray *orderData;

- (Order *)initWithOrderId:(NSString *)oid orderStatus:(ORDER_STATUS)status orderData:(NSMutableArray *)data;
- (NSUInteger)getTotalProductNum;
- (CGFloat)getTotalPrice;
- (NSUInteger)getProductNum;
@end
