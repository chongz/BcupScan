//
//  BasicCake.h
//  BakeCake
//
//  Created by zhangchong on 8/10/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BasicCake : NSObject
@property (nonatomic, strong) NSString *pid;//蛋糕id-->pid
@property (nonatomic, strong) NSString *materialName;//材料名称-->materialsName
@property (nonatomic, strong) NSString *cutOverPicName;//图片名称(切面图）-->cutPic
@property (nonatomic, strong) NSString *overLookPicName;//图片名称（俯瞰图）-->overPic
@property (nonatomic, strong) NSString *overLookFrontPicName;
@property (nonatomic, strong) NSString *selectPicName;//选择图片名称-->defaultPic
@property (nonatomic, strong) NSString *selectPicServerName;//服务端选择图片名称-->defaultPic
@property (nonatomic, strong) NSString *basicCakeType;//蛋糕类型-->materialsKind
@property (nonatomic, assign) CGFloat  materialPrice;//材料价格 -->price
@property (nonatomic, strong) NSString *updateDate;//更新日期-->lastUpdateTime
@property (nonatomic, strong) NSString *status;//材料状态--->materialState
@property (nonatomic, strong) NSString *cityIds;//城市id以,分隔
@property (nonatomic, strong) NSString *cutOverPicServerName;//服务端图片名称(切面图）-->cutPic
@property (nonatomic, strong) NSString *overLookPicServerName;//服务端图片名称（俯瞰图）-->overPic
@property (nonatomic, strong) NSString *overLookFrontPicServerName;//服务端图片名称（俯瞰图前)
- (BasicCake *)initWithDic:(NSDictionary *)dic;
@end
