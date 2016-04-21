//
//  CityStore.h
//  BakeCake
//
//  Created by zhangchong on 9/7/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Store;

@interface CityStore : NSObject <NSCoding>
@property (nonatomic, strong) NSString       *cityID;
@property (nonatomic, strong) NSString       *cityName;
@property (nonatomic, strong) NSString       *cityPicAddress;
@property (nonatomic, strong) NSMutableArray *stores;
@property (nonatomic, strong) NSString       *cityPic;
@property (nonatomic, strong) NSString       *cityServerPic;
@property (nonatomic, strong) NSString       *updateTime;
@property (nonatomic, strong) NSString       *cityRange;

- (CityStore *)initWithCityName:(NSString *)name stores:(NSMutableArray *) array;
- (CityStore *)initWithDic:(NSDictionary *)dic;
@end
