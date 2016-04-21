//
//  FlavorCupcake.m
//  BakeCake
//
//  Created by zhangchong on 10/19/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "FlavorCupcake.h"
#import "ResouceManager.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation FlavorCupcake
@synthesize updateTime;
@synthesize productDes;
@synthesize cutPic;
@synthesize overPic;
@synthesize productPrice;
@synthesize productName;
@synthesize productID;
@synthesize productKind;
@synthesize productType;
@synthesize productState;
@synthesize productStuffing;
@synthesize productTopping;
@synthesize productCake;
@synthesize productIcing;
@synthesize productTime;

@synthesize cupcake;

- (FlavorCupcake *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.updateTime      = [dic objectAvoidNullKey:@"updateTime"];
        self.productDes      = [dic objectAvoidNullKey:@"productDes"];
        self.cutPic          = [dic objectAvoidNullKey:@"cutPic"];
        self.overPic         = [dic objectAvoidNullKey:@"overPic"];
        self.productPrice    = [dic objectAvoidNullKey:@"productPrice"];
        self.productName     = [dic objectAvoidNullKey:@"productName"];
        self.productID       = [dic objectAvoidNullKey:@"productID"];
        self.productKind     = [dic objectAvoidNullKey:@"productKind"];
        self.productTime     = [dic objectAvoidNullKey:@"productTime"];
        self.productType     = [dic objectAvoidNullKey:@"productType"];
        self.productState    = [dic objectAvoidNullKey:@"productState"];
        self.productStuffing = [dic objectAvoidNullKey:@"productStuffing"];
        self.productTopping  = [dic objectAvoidNullKey:@"productTopping"];
        self.productCake     = [dic objectAvoidNullKey:@"productCake"];
        self.productIcing    = [dic objectAvoidNullKey:@"productIcing"];
        
        Cake *cake = nil;
        if (self.productCake) {
            cake = [[ResouceManager sharedInstance] queryCakeTalbe:self.productCake];
        }
        
        Icing *icing = nil;
        if (self.productIcing) {
            icing = [[ResouceManager sharedInstance] queryIcingTalbe:self.productIcing];
        }
        
        Topping *topping = nil;
        if (self.productTopping) {
            topping = [[ResouceManager sharedInstance] queryToppingTalbe:self.productTopping];
        }
        
        Stuffing *stuffing = nil;
        if (self.productStuffing) {
            stuffing = [[ResouceManager sharedInstance] queryStuffingTalbe:self.productStuffing];
        }
        
        self.cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];

    }
    return self;
}
@end
