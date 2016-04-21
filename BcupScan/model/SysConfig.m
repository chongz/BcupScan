//
//  SysConfig.m
//  BakeCake
//
//  Created by zhangchong on 10/30/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "SysConfig.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation SysConfig
@synthesize argumentKey;
@synthesize argumentValue;


- (SysConfig *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        self.argumentKey   = [dic objectAvoidNullKey:@"argumentKey"];
        self.argumentValue = [dic objectAvoidNullKey:@"argumentValue"];
    }
    
    return self;
}
@end
