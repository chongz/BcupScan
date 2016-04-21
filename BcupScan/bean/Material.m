//
//  Material.m
//  BakeCake
//
//  Created by zhangchong on 10/9/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "Material.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation Material
@synthesize materialsName;
@synthesize price;
@synthesize materialState;
@synthesize lastUpdateTime;
@synthesize materialsKind;
@synthesize cutPic;
@synthesize overPic;
@synthesize pid;
@synthesize defaultPic;


- (Material *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.materialsName  = [dic objectAvoidNullKey:@"materialsName"];
        self.price          = [dic objectAvoidNullKey:@"price"];
        self.materialState  = [dic objectAvoidNullKey:@"materialState"];
        self.lastUpdateTime = [dic objectAvoidNullKey:@"lastUpdateTime"];
        self.materialsKind  = [dic objectAvoidNullKey:@"materialsKind"];
        self.cutPic         = [dic objectAvoidNullKey:@"cutPic"];
        self.overPic        = [dic objectAvoidNullKey:@"overPic"];
        self.pid            = [dic objectAvoidNullKey:@"pid"];
        self.defaultPic     = [dic objectAvoidNullKey:@"defaultPic"];
    }
    
    return self;
}

@end
