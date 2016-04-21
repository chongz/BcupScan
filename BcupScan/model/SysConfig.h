//
//  SysConfig.h
//  BakeCake
//
//  Created by zhangchong on 10/30/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysConfig : NSObject
@property (nonatomic, strong) NSString *argumentKey;
@property (nonatomic, strong) NSString *argumentValue;
- (SysConfig *)initWithDic:(NSDictionary *)dic;
@end
