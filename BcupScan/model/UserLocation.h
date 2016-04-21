//
//  UserLocation.h
//  BakeCake
//
//  Created by zhangchong on 11/2/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocation : NSObject
@property (nonatomic, strong) NSString *memberPhone;
@property (nonatomic, strong) NSString *reqLocKind;//1 登录,2 下订单
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *detailedAdd;
@property (nonatomic, strong) NSString *updateTime;
@end
