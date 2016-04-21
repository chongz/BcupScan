//
//  Customer.h
//  BakeCake
//
//  Created by zhangchong on 9/15/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerAddress : NSObject <NSCoding>
@property (nonatomic, strong) NSString *addressPhone;
@property (nonatomic, strong) NSString *addressDefault;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *memberPhone;
@property (nonatomic, strong) NSString *addressCode;
@property (nonatomic, strong) NSString *addressDetailed;
@property (nonatomic, strong) NSString *addressDistrict;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *addressCityId;
@property (nonatomic, strong) NSString *addressID;
@property (nonatomic, strong) NSString *addressName;
@property (nonatomic, strong) NSString *addressReceiver;
@property (nonatomic, strong) NSString *addressDetailText;

- (CustomerAddress *)initWithDic:(NSDictionary *)dic;
@end
