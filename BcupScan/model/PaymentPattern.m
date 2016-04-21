//
//  PaymentPattern.m
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "PaymentPattern.h"

@implementation PaymentPattern
@synthesize paymentPatternText;
@synthesize paymentPatternMode;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.paymentPatternText  forKey:@"paymentPatternText"];
    [aCoder encodeObject:self.paymentPatternMode forKey:@"paymentPatternMode"];
  
}

- (PaymentPattern *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.paymentPatternText = [aDecoder decodeObjectForKey:@"paymentPatternText"];
        self.paymentPatternMode = [aDecoder decodeObjectForKey:@"paymentPatternMode"];
    }
    
    return self;
}

@end
