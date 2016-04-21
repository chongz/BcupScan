//
//  Store.h
//  BakeCake
//
//  Created by zhangchong on 12/7/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject <NSCoding>
@property (nonatomic, strong  ) NSString       *storeID;
@property (nonatomic, strong  ) NSString       *storeCityID;
@property (nonatomic, strong  ) NSString       *storeName;
@property (nonatomic, strong  ) NSString       *storePhone;
@property (nonatomic, strong  ) NSString       *storeLatitude;
@property (nonatomic, strong  ) NSString       *storeLongitude;
@property (nonatomic, strong  ) NSString       *storeAddress;
@property (nonatomic, strong  ) NSString       *storeWorktime;
@property (nonatomic, strong  ) NSString       *storeSaturdayWorkTime;
@property (nonatomic, strong  ) NSString       *storeSundayWorkTime;
@property (nonatomic, strong  ) NSString       *updateTime;

//@property (nonatomic, strong) NSMutableArray *workArrayTime;
- (Store *)initWithDic:(NSDictionary *)dic;
@end
