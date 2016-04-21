//
//  NSString+InputCheck.m
//  BakeCake
//
//  Created by zhangchong on 10/15/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "NSString+InputCheck.h"
@implementation NSString (InputCheck)
- (BOOL) validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}



// ^[0-9]+$
- (BOOL) validateMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
- (BOOL) validateUserId
{
    NSString *userIdRegex = @"^[0-9]+$";
    NSPredicate *userIdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userIdRegex];
    BOOL B = [userIdPredicate evaluateWithObject:self];
    
    if (![self hasPrefix:@"1"] && B) {
        return NO;
    }
    
    return B;
}



- (BOOL) validateqq
{
    
    NSString *qqRegex = @"^[0-9]+$";
    
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqRegex];
    
    return [qqTest evaluateWithObject:self];
    
}



- (BOOL) validateRealName

{
    
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [passWordPredicate evaluateWithObject:self];
    
}



- (BOOL) validateNickName{
    
    NSString *userNameRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,24}+$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    
    BOOL B = [userNamePredicate evaluateWithObject:self];
    
    return B;
    
}

@end

