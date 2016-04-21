//
//  NewOrder.m
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "NewOrder.h"

@implementation NewOrder 
//@synthesize customerAddress;
@synthesize deliverySelector;
@synthesize deliveryDate;
@synthesize deliveryTime;
@synthesize deliveryMsg;
@synthesize paymentPattern;
@synthesize deliverCost;
@synthesize deliverKind;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deliverySelector forKey:@"deliverySelector"];
    [aCoder encodeObject:self.deliveryDate     forKey:@"deliveryDate"];
    [aCoder encodeObject:self.deliveryTime     forKey:@"deliveryTime"];
    [aCoder encodeObject:self.deliveryMsg      forKey:@"deliveryMsg"];
    [aCoder encodeObject:self.paymentPattern   forKey:@"paymentPattern"];
    [aCoder encodeObject:self.deliverCost      forKey:@"deliverCost"];
    [aCoder encodeObject:self.deliverKind      forKey:@"deliverKind"];
}

- (NewOrder *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.deliverySelector = [aDecoder decodeObjectForKey:@"deliverySelector"];
        self.deliveryDate     = [aDecoder decodeObjectForKey:@"deliveryDate"];
        self.deliveryTime     = [aDecoder decodeObjectForKey:@"deliveryTime"];
        self.deliveryMsg      = [aDecoder decodeObjectForKey:@"deliveryMsg"];
        self.paymentPattern   = [aDecoder decodeObjectForKey:@"paymentPattern"];
        self.deliverCost      = [aDecoder decodeObjectForKey:@"deliverCost"];
        self.deliverKind      = [aDecoder decodeObjectForKey:@"deliverKind"];
    }
    
    return self;
}
@end
