//
//  NSDictionary+NoneKeyCheck.m
//  BakeCake
//
//  Created by zhangchong on 10/19/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "NSDictionary+NoneKeyCheck.h"

@implementation NSDictionary (NoneKeyCheck)
- (NSString *)objectAvoidNullKey:(NSString *)key {
    

    
    NSString *obj = [self objectForKey:key];
    if ([obj isEqual: [NSNull null]]) {
        return @"";
    }
    
    if (obj == nil || [obj length] == 0) {
        return @"";
    }
    
    return obj;
}
@end
