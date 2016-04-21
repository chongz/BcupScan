//
//  Product.h
//  BakeCake
//
//  Created by zhangchong on 9/6/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductItem.h"
#import "Constants.h"

@interface Product : NSObject
@property (nonatomic, strong) NSString       *productName;
@property (nonatomic, strong) NSString       *productSubName;
@property (nonatomic, strong) NSString       *productPicName;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) float          productPrice;

- (Product *)initWithName:(NSString *)pname;

@end
