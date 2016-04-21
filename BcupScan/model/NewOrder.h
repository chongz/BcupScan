//
//  NewOrder.h
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerAddress.h"
#import "PaymentPattern.h"

@interface NewOrder : NSObject <NSCoding>
@property (nonatomic, strong) NSString       *deliverySelector;
@property (nonatomic, strong) NSString       *deliverKind;
@property (nonatomic, strong) NSString       *deliverCost;
@property (nonatomic, strong) NSString       *deliveryDate;
@property (nonatomic, strong) NSString       *deliveryTime;
@property (nonatomic, strong) NSString       *deliveryMsg;
@property (nonatomic, strong) PaymentPattern *paymentPattern;
@end
