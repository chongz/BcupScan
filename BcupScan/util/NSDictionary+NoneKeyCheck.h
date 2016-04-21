//
//  NSDictionary+NoneKeyCheck.h
//  BakeCake
//
//  Created by zhangchong on 10/19/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NoneKeyCheck)
- (NSString *)objectAvoidNullKey:(NSString *)key;
@end
