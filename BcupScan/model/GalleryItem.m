//
//  GalleryItem.m
//  BakeCake
//
//  Created by zhangchong on 11/1/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "GalleryItem.h"

@implementation GalleryItem
@synthesize type;
@synthesize memeberId;
@synthesize memeberPhone;
@synthesize cakeName;
@synthesize cakeType;
@synthesize cakePrice;
@synthesize creator;
@synthesize createTime;
@synthesize updateTime;
@synthesize lookOverPicAddress;
@synthesize cutoverPicAddress;
@synthesize isSendPublicGallery;
@synthesize cupcake;
@synthesize flavorProduct;
@synthesize flavorCupcake;

- (GalleryItem *)initWithCupcake:(CupCake *)_cupcake {
    self = [super init];
    if (self) {
        self.cupcake  = _cupcake;
        self.type     = @"1";
        self.cakeName = _cupcake.cakeName;
        self.creator  = _cupcake.memberPhone;
        self.customID = _cupcake.cakeId;
    }
    
    return self;
}

- (GalleryItem *)initWithFlavorCupcake:(FlavorCupcake *)_flavorCupcake {
    self = [super init];
    if (self) {
        self.flavorCupcake = _flavorCupcake;
        self.type          = @"2";
    }
    
    return self;
}

- (GalleryItem *)initWithFlavorProduct:(FlavorProduct *)_flavorProduct {
    self = [super init];
    if (self) {
        self.flavorProduct = _flavorProduct;
        self.type          = @"3";
    }
    
    return self;
}

@end
