//
//  PickByCustomer.h
//  BakeCake
//
//  Created by zhangchong on 12/8/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Store;

@interface PickByCustomer : NSObject <NSCoding>
@property (nonatomic, strong) NSString *picker;
@property (nonatomic, strong) NSString *pickerPhone;
@property (nonatomic, strong) Store    *store;
@end
