//
//  PickByCustomer.m
//  BakeCake
//
//  Created by zhangchong on 12/8/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "PickByCustomer.h"

@implementation PickByCustomer
@synthesize picker;
@synthesize pickerPhone;
@synthesize store;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.picker  forKey:@"picker"];
    [aCoder encodeObject:self.pickerPhone forKey:@"pickerPhone"];
    [aCoder encodeObject:self.store forKey:@"pickByCustomerStore"];
}

- (PickByCustomer *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.picker    = [aDecoder decodeObjectForKey:@"picker"];
        self.pickerPhone = [aDecoder decodeObjectForKey:@"pickerPhone"];
        self.store = [aDecoder decodeObjectForKey:@"pickByCustomerStore"];
    }
    
    return self;
}
@end
