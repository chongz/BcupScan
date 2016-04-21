//
//  PaymentPattern.h
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentPattern : NSObject <NSCoding>
@property (nonatomic, strong) NSString *paymentPatternText;
@property (nonatomic, strong) NSString *paymentPatternMode;
@end
