//
//  NSString+stringFormatCurrency.m
//  BakeCake
//
//  Created by zhangchong on 8/31/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "NSString+stringFormatCurrency.h"

@implementation NSString (stringFormatCurrency)
- (NSString *)formatCurrency {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setMinimumIntegerDigits:1];
    NSNumber *number = [formatter numberFromString:self];
    NSString *str = [formatter stringFromNumber:number];
    return [@"￥" stringByAppendingString:str];
}

- (NSString *)formatCurrencyAfter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setMinimumIntegerDigits:1];
    NSNumber *number = [formatter numberFromString:self];
    NSString *str = [formatter stringFromNumber:number];
    return [str stringByAppendingString:@"￥"];
}

- (NSString *)formatNum {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setMinimumIntegerDigits:1];
    NSNumber *number = [formatter numberFromString:self];
    NSString *str = [formatter stringFromNumber:number];
    return str;
}
@end
