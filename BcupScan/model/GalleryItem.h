//
//  GalleryItem.h
//  BakeCake
//
//  Created by zhangchong on 11/1/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CupCake.h"
#import "FlavorCupcake.h"
#import "FlavorProduct.h"

@interface GalleryItem : NSObject
@property (nonatomic, strong) NSString      *customID;
@property (nonatomic, strong) NSString      *type;
@property (nonatomic, strong) NSString      *memeberId;
@property (nonatomic, strong) NSString      *memeberPhone;
@property (nonatomic, strong) NSString      *cakeName;
@property (nonatomic, strong) NSString      *cakeType;
@property (nonatomic, strong) NSString      *cakePrice;
@property (nonatomic, strong) NSString      *creator;
@property (nonatomic, strong) NSString      *createTime;
@property (nonatomic, strong) NSString      *updateTime;
@property (nonatomic, strong) NSString      *lookOverPicAddress;
@property (nonatomic, strong) NSString      *cutoverPicAddress;
@property (nonatomic, assign) NSString      *isSendPublicGallery;
@property (nonatomic, strong) CupCake       *cupcake;
@property (nonatomic, strong) FlavorCupcake *flavorCupcake;
@property (nonatomic, strong) FlavorProduct *flavorProduct;
- (GalleryItem *)initWithCupcake:(CupCake *)cupcake;
- (GalleryItem *)initWithFlavorCupcake:(FlavorCupcake *)flavorCupcake;
- (GalleryItem *)initWithFlavorProduct:(FlavorProduct *)flavorProduct;
@end
