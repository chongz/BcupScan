//
//  DeliveryPattern.h
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryPattern : NSObject <NSCoding>
@property (nonatomic, strong) NSString *deliveryPatternText;
@property (nonatomic, strong) NSString *deliveryPatternCost;
@end
