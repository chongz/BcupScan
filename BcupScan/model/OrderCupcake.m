//
//  OrderCupcake.m
//  BakeCake
//
//  Created by zhangchong on 9/22/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "OrderCupcake.h"


@implementation OrderCupcake
@synthesize flavorCupcake;
@synthesize cupcake;
@synthesize flavorProduct;
@synthesize type;
@synthesize num;

- (OrderCupcake *)initWithCupcake:(CupCake *)cc cupcakeNum:(NSUInteger)ccNum {
    self = [super init];
    if (self) {
        self.cupcake = cc;
        self.num     = ccNum;
        self.type    = @"1";
    }
    
    return self;
}

- (OrderCupcake *)initWithFlavorCupcake:(FlavorCupcake *)_flavorCupcake cupcakeNum:(NSUInteger)_num {
    self = [super init];
    if (self) {
        self.flavorCupcake = _flavorCupcake;
        self.num           = _num;
        self.type          = @"2";
    }
    return self;
}


- (OrderCupcake *)initWithFlavorProduct:(FlavorProduct *)_flavorProduct cupcakeNum:(NSUInteger)_num {
    self = [super init];
    if (self) {
        self.flavorProduct = _flavorProduct;
        self.num           = _num;
        self.type          = @"3";
    }
    return self;
}

- (CGFloat)getPrice {
    CGFloat totalPrice = 0.0f;
    if ([@"1" isEqualToString:self.type]) {
        totalPrice = [self.cupcake getPrice] * num;
    }else if([@"2" isEqualToString:self.type]){
        totalPrice = [self.flavorCupcake.cupcake getPrice] * num;
    }else if([@"3" isEqualToString:self.type]){
        totalPrice = [[self.flavorProduct productPrice] floatValue] * num;
    }
    return totalPrice;
}
@end
