//
//  NSString+InputCheck.h
//  BakeCake
//
//  Created by zhangchong on 10/15/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (InputCheck)

- (BOOL) validateEmail;

- (BOOL) validateMobile;

- (BOOL) validateqq;

- (BOOL) validateRealName;

- (BOOL) validateNickName;

- (BOOL) validateUserId;

@end
