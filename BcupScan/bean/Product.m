//
//  Product.m
//  BakeCake
//
//  Created by zhangchong on 9/6/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize productName;
@synthesize productSubName;
@synthesize productPicName;
@synthesize items;
@synthesize productPrice;

- (Product *)initWithName:(NSString *)pname {
    self = [super init];
    if (self) {
        self.productName = pname;
        self.items       = [[NSMutableArray alloc] init];
    }
    
    return self;
}
@end
