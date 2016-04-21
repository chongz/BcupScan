//
//  DataUtil.h
//  BakeCake
//
//  Created by zhangchong on 9/6/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtil : NSObject
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isIdCard:(NSString *)sPaperId;
+ (BOOL)isValidZipcode:(NSString*)value;
@end
