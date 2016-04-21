//
//  CustomerCupcake.h
//  BakeCake
//
//  Created by zhangchong on 10/17/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerCupcake : NSObject
@property (nonatomic, strong) NSString *customName;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *customCake;
@property (nonatomic, strong) NSString *customIcing;
@property (nonatomic, strong) NSString *customStuffing;
@property (nonatomic, strong) NSString *customTopping;
@property (nonatomic, strong) NSString *customState;

- (CustomerCupcake *)initWithDic:(NSDictionary *)dic;

@end
