//
//  Order.m
//  BakeCake
//
//  Created by zhangchong on 9/22/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "Order.h"

@implementation Order
@synthesize orderId;
@synthesize orderStatus;
@synthesize orderData;

- (Order *)initWithOrderId:(NSString *)oid orderStatus:(ORDER_STATUS)status orderData:(NSMutableArray *)data {
    self = [super init];
    if (self) {
        self.orderId = oid;
        self.orderStatus = status;
        self.orderData = data;
    }
    return self;
}

- (NSUInteger)getTotalProductNum {
    NSUInteger totalNum = 0;
    for (OrderCupcake *occ in self.orderData) {
        totalNum += occ.num;
    }
    return totalNum;
}

- (CGFloat)getTotalPrice {
    CGFloat totalPrice = 0;
    for (OrderCupcake *occ in self.orderData) {
        totalPrice += [occ.cupcake getPrice] * occ.num;
    }
    
    return totalPrice;
}

- (NSUInteger)getProductNum {
    if (self.orderData) {
        return [orderData count];
    }
    
    return 0;
}
@end
