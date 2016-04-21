//
//  OrderCupcake.h
//  BakeCake
//
//  Created by zhangchong on 9/22/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cupcake.h"
#import "FlavorCupcake.h"
#import "FlavorProduct.h"

@interface OrderCupcake : NSObject
@property (nonatomic, strong) CupCake       *cupcake;
@property (nonatomic, strong) FlavorCupcake *flavorCupcake;
@property (nonatomic, strong) FlavorProduct *flavorProduct;
@property (nonatomic, strong) NSString      *type;
@property (nonatomic, assign) NSUInteger    num;

- (OrderCupcake *)initWithCupcake:(CupCake *)cupcake cupcakeNum:(NSUInteger)num;
- (OrderCupcake *)initWithFlavorCupcake:(FlavorCupcake *)flavorCupcake cupcakeNum:(NSUInteger)num;
- (OrderCupcake *)initWithFlavorProduct:(FlavorProduct *)flavorProduct cupcakeNum:(NSUInteger)num;
- (CGFloat)getPrice;
@end
