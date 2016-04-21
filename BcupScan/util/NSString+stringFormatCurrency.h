//
//  NSString+stringFormatCurrency.h
//  BakeCake
//
//  Created by zhangchong on 8/31/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (stringFormatCurrency)
- (NSString *)formatCurrency;
- (NSString *)formatCurrencyAfter;
- (NSString *)formatNum;
@end
