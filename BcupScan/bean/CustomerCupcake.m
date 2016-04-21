//
//  CustomerCupcake.m
//  BakeCake
//
//  Created by zhangchong on 10/17/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "CustomerCupcake.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation CustomerCupcake
@synthesize customName;
@synthesize memberID;
@synthesize customCake;
@synthesize customIcing;
@synthesize customStuffing;
@synthesize customTopping;
@synthesize customState;

- (CustomerCupcake *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.customName     = [dic objectAvoidNullKey:@"customName"];
        self.memberID       = [dic objectAvoidNullKey:@"memberID"];
        self.customCake     = [dic objectAvoidNullKey:@"customCake"];
        self.customIcing    = [dic objectAvoidNullKey:@"customIcing"];
        self.customStuffing = [dic objectAvoidNullKey:@"customStuffing"];
        self.customTopping  = [dic objectAvoidNullKey:@"customTopping"];
        self.customState    = [dic objectAvoidNullKey:@"customState"];
    }
    
    return self;
}
@end
