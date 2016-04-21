//
//  NSDate+currentTime.m
//  BakeCake
//
//  Created by zhangchong on 10/23/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "NSDate+currentTime.h"

@implementation NSDate (currentTime)
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (NSInteger)currentDateHour {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return [dateTime integerValue] + 1;
}
@end
