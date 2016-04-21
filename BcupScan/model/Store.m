//
//  Store.m
//  BakeCake
//
//  Created by zhangchong on 12/7/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "Store.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation Store
@synthesize storeID,storeName,storePhone,storeCityID,storeAddress,storeLatitude,storeWorktime,storeLongitude,storeSundayWorkTime,storeSaturdayWorkTime,updateTime;
//@synthesize workArrayTime;

- (Store *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        self.storeID               = [dic objectAvoidNullKey:@"storeID"];
        self.storeCityID           = [dic objectAvoidNullKey:@"storeCity"];
        self.storeName             = [dic objectAvoidNullKey:@"storeName"];
        self.storePhone            = [dic objectAvoidNullKey:@"storePhone"];
        self.storeLatitude         = [dic objectAvoidNullKey:@"storeLatitude"];
        self.storeLongitude        = [dic objectAvoidNullKey:@"storeLongitude"];
        self.storeAddress          = [dic objectAvoidNullKey:@"storeAddress"];
        self.storeWorktime         = [dic objectAvoidNullKey:@"storeWorktime"];
        self.storeSaturdayWorkTime = [dic objectAvoidNullKey:@"storeSaturdayWorkTime"];
        self.storeSundayWorkTime   = [dic objectAvoidNullKey:@"storeSundayWorkTime"];
        self.updateTime            = [dic objectAvoidNullKey:@"updateTime"];
    }
    
    //storeWorktime format is xx:00-xx:00.[8:00-20:00]
    
//    self.workArrayTime = [[NSMutableArray alloc] initWithArray:[self.storeWorktime componentsSeparatedByString:@"-"]];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.storeID  forKey:@"storeID"];
    [aCoder encodeObject:self.storeCityID forKey:@"storeCityID"];
    [aCoder encodeObject:self.storeName  forKey:@"storeName"];
    [aCoder encodeObject:self.storePhone forKey:@"storePhone"];
    [aCoder encodeObject:self.storeLatitude  forKey:@"storeLatitude"];
    [aCoder encodeObject:self.storeLongitude forKey:@"storeLongitude"];
    [aCoder encodeObject:self.storeAddress  forKey:@"storeAddress"];
    [aCoder encodeObject:self.storeWorktime forKey:@"storeWorktime"];
    [aCoder encodeObject:self.storeSaturdayWorkTime  forKey:@"storeSaturdayWorkTime"];
    [aCoder encodeObject:self.storeSundayWorkTime forKey:@"storeSundayWorkTime"];
    [aCoder encodeObject:self.updateTime forKey:@"updateTime"];
}

- (Store *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.storeID               = [aDecoder decodeObjectForKey:@"storeID"];
        self.storeCityID           = [aDecoder decodeObjectForKey:@"storeCityID"];
        self.storeName             = [aDecoder decodeObjectForKey:@"storeName"];
        self.storePhone            = [aDecoder decodeObjectForKey:@"storePhone"];
        self.storeLatitude         = [aDecoder decodeObjectForKey:@"storeLatitude"];
        self.storeLongitude        = [aDecoder decodeObjectForKey:@"storeLongitude"];
        self.storeAddress          = [aDecoder decodeObjectForKey:@"storeAddress"];
        self.storeWorktime         = [aDecoder decodeObjectForKey:@"storeWorktime"];
        self.storeSaturdayWorkTime = [aDecoder decodeObjectForKey:@"storeSaturdayWorkTime"];
        self.storeSundayWorkTime   = [aDecoder decodeObjectForKey:@"storeSundayWorkTime"];
        self.updateTime            = [aDecoder decodeObjectForKey:@"updateTime"];
    }
    
    return self;
}

@end
