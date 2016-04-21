//
//  BasicCake.m
//  BakeCake
//
//  Created by zhangchong on 8/10/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "BasicCake.h"
#import "ResouceManager.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation BasicCake
@synthesize pid;
@synthesize cutOverPicName;
@synthesize overLookPicName;
@synthesize selectPicName;
@synthesize basicCakeType;
@synthesize materialName;
@synthesize materialPrice;
@synthesize updateDate;
@synthesize status;
@synthesize overLookPicServerName;
@synthesize cutOverPicServerName;
@synthesize selectPicServerName;
@synthesize overLookFrontPicName;
@synthesize overLookFrontPicServerName;
@synthesize cityIds;

- (BasicCake *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.pid                        = [dic objectAvoidNullKey:@"materialID"];
        self.materialName               = [dic objectAvoidNullKey:@"materialName"];
        self.materialPrice              = [[dic objectAvoidNullKey:@"price"] floatValue];
        self.status                     = [dic objectAvoidNullKey:@"materialState"];
        self.updateDate                 = [dic objectAvoidNullKey:@"lastUpdateTime"];
        self.basicCakeType              = [dic objectAvoidNullKey:@"materialKind"];

        self.cutOverPicServerName       = [dic objectAvoidNullKey:@"cutPic"];
        self.overLookPicServerName      = [dic objectAvoidNullKey:@"overPic"];
        self.selectPicServerName        = [dic objectAvoidNullKey:@"selectPic"];
        self.overLookFrontPicServerName = [dic objectAvoidNullKey:@"overfrontPic"];
        
        
        NSMutableArray *cids = [[NSMutableArray alloc] init];
        NSArray *cities = [dic objectForKey:@"materialCity"];

        for (NSDictionary *ele in cities) {
            NSString *cityID = [ele objectAvoidNullKey:@"cityID"];
            [cids addObject:cityID];
        }
        
        NSMutableString *temp = [[NSMutableString alloc] init];
        for (int i=0; i< [cids count]; i++) {
            NSString *cid = [cids objectAtIndex:i];
            [temp appendString:cid];
            if (i < [cids count] - 1) {
                 [temp appendString:@","];
            }
        }
        
        self.cityIds = temp;
        
        
        self.cutOverPicName       = [[ResouceManager sharedInstance] getFileName:self.cutOverPicServerName];
        self.overLookPicName      = [[ResouceManager sharedInstance] getFileName:self.overLookPicServerName];
        self.overLookFrontPicName = [[ResouceManager sharedInstance] getFileName:self.overLookFrontPicServerName];
        self.selectPicName        = [[ResouceManager sharedInstance] getFileName:self.selectPicServerName];
        
    }
    
    return self;
}

@end
