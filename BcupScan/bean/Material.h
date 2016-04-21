//
//  Material.h
//  BakeCake
//
//  Created by zhangchong on 10/9/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Material : NSObject
@property (nonatomic, strong) NSString *materialsName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *materialState;
@property (nonatomic, strong) NSString *lastUpdateTime;
@property (nonatomic, strong) NSString *materialsKind;
@property (nonatomic, strong) NSString *cutPic;
@property (nonatomic, strong) NSString *overPic;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *defaultPic;

- (Material *)initWithDic:(NSDictionary *)dic;
@end
