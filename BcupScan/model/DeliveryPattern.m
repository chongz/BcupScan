//
//  DeliveryPattern.m
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "DeliveryPattern.h"

@implementation DeliveryPattern
@synthesize deliveryPatternCost;
@synthesize deliveryPatternText;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deliveryPatternCost  forKey:@"deliveryPatternCost"];
    [aCoder encodeObject:self.deliveryPatternText forKey:@"deliveryPatternText"];
    
}

- (DeliveryPattern *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.deliveryPatternText = [aDecoder decodeObjectForKey:@"deliveryPatternText"];
        self.deliveryPatternCost = [aDecoder decodeObjectForKey:@"deliveryPatternCost"];
    }
    
    return self;
}
@end
