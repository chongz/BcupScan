//
//  CupCake.m
//  BakeCake
//
//  Created by zhangchong on 8/10/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "CupCake.h"
#import "Constants.h"
#import "NSDictionary+NoneKeyCheck.h"
#import "ResouceManager.h"

@implementation CupCake
@synthesize cake;
@synthesize icing;
@synthesize stuffing;
@synthesize topping;
@synthesize cakePrice;
@synthesize creator;
@synthesize lookoverPicAddress;
@synthesize cutoverPicAddress;
@synthesize isSendPublicGallery;
@synthesize cakeId;
@synthesize creatorEmail;
@synthesize customCake;
@synthesize customStuffing;
@synthesize customTopping;
@synthesize customIcing;
@synthesize updateTime;

-(CupCake *) initWithCake:(Cake*) _cake icing:(Icing*) _icing stuffing:(Stuffing *) _stuffing topping:(Topping *) _topping {
    
    self = [[CupCake alloc] init];
    if (self) {
        self.cake     = _cake;
        self.icing    = _icing;
        self.topping  = _topping;
        self.stuffing = _stuffing;
        [self updatePrice];
    }

    return self;
}


- (CupCake *)initWithCake:(Cake*) _cake icing:(Icing*) _icing stuffing:(Stuffing *) _stuffing topping:(Topping *)_topping creator:(NSString *)_creator {
    self = [[CupCake alloc] initWithCake:_cake icing:_icing stuffing:_stuffing topping:_topping];
    if (self) {
        self.creator = _creator;
    }
    return self;
}

- (CupCake *)initWithGalleryDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.cakeId         = [dic objectAvoidNullKey:@"customID"];
        self.customStuffing = [dic objectAvoidNullKey:@"customStuffing"];
        self.customCake     = [dic objectAvoidNullKey:@"customCake"];
        self.customTopping  = [dic objectAvoidNullKey:@"customTopping"];
        self.cakeName       = [dic objectAvoidNullKey:@"customName"];
        self.customIcing    = [dic objectAvoidNullKey:@"customIcing"];
        self.memberPhone    = [dic objectAvoidNullKey:@"memberPhone"];
        self.updateTime     = [dic objectAvoidNullKey:@"updateTime"];
        
        self.cake = [[ResouceManager sharedInstance] queryCakeTalbe:self.customCake];
        self.icing = [[ResouceManager sharedInstance] queryIcingTalbe:self.customIcing];
        if ([@"" isEqualToString:self.customTopping]) {
            self.customTopping = kDefaultToppingId;
        }else{
            self.topping = [[ResouceManager sharedInstance] queryToppingTalbe:self.customTopping];
        }
        if ([@"" isEqualToString:self.customStuffing]) {
            self.customStuffing = kDefaultStuffingId;
        }else {
            self.stuffing = [[ResouceManager sharedInstance] queryStuffingTalbe:self.customStuffing];
        }
        
        [[ResouceManager sharedInstance] closeDb];
    }
    
    return self;
}

- (void)updatePrice {
    CGFloat currentPrice = self.cake.materialPrice + self.icing.materialPrice;
    if (self.stuffing) {
        currentPrice += self.stuffing.materialPrice;
    }
    
    if (self.topping) {
        currentPrice += self.topping.materialPrice;
    }
    
    cakePrice = currentPrice;
}

- (CGFloat)getPrice {
    [self updatePrice];
    return cakePrice;
}

@end
