//
//  DeliveryWay.m
//  BakeCake
//
//  Created by zhangchong on 12/7/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "DeliveryWay.h"

@implementation DeliveryWay
@synthesize deliveryWay;
@synthesize deliveryCharge;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deliveryWay  forKey:@"deliveryWay"];
    [aCoder encodeObject:self.deliveryCharge forKey:@"deliveryCharge"];
    
}

- (DeliveryWay *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.deliveryWay    = [aDecoder decodeObjectForKey:@"deliveryWay"];
        self.deliveryCharge = [aDecoder decodeObjectForKey:@"deliveryCharge"];
    }
    
    return self;
}
@end
