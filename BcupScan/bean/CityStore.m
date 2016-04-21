//
//  CityStore.m
//  BakeCake
//
//  Created by zhangchong on 9/7/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "CityStore.h"
#import "StoreInfo.h"
#import "NSDictionary+NoneKeyCheck.h"
#import "ResouceManager.h"
#import "Store.h"

@implementation CityStore
@synthesize cityID;
@synthesize cityName;
@synthesize cityPicAddress;
@synthesize stores;
@synthesize cityPic;
@synthesize updateTime;
@synthesize cityRange;
@synthesize cityServerPic;

- (CityStore *)initWithCityName:(NSString *)name  stores:(NSMutableArray *) array {
    self = [super init];
    self.cityName = name;
    self.stores = array;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cityID  forKey:@"cityID"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
}

- (CityStore *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.cityID = [aDecoder decodeObjectForKey:@"cityID"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.stores = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (CityStore *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.cityID        = [dic objectAvoidNullKey:@"cityID"];
        self.cityName      = [dic objectAvoidNullKey:@"cityName"];
        self.cityServerPic = [dic objectAvoidNullKey:@"cityPic"];
        self.cityPic       = [[ResouceManager sharedInstance] getFileName:self.cityServerPic];
        self.updateTime    = [dic objectAvoidNullKey:@"updateTime"];
        self.cityRange     = [dic objectAvoidNullKey:@"cityRange"];
        self.stores        = [[NSMutableArray alloc] init];
        
        NSArray *listStore = [dic objectForKey:@"storeInfo"];
        if (listStore != nil) {
            for (NSDictionary *storeDic in listStore) {
                Store *store = [[Store alloc] initWithDic:storeDic];
                [self.stores addObject:store];
            }
        }
    }
    
    return self;
}
@end
