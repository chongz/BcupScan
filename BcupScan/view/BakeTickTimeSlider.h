//
//  BakeTickTimeSlider.h
//  BakeCake
//
//  Created by zhangchong on 9/9/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BakeTickTimeSlider : UIControl

@property (nonatomic, strong) UITextField *indicatedTextField;
@property (nonatomic, strong) UITextField *indicatedTextLabelField;
@property (nonatomic, assign) CGFloat     angle;
@property (nonatomic, assign) CGFloat     radius;
@property (nonatomic, assign) NSUInteger  remaindTime;

-(id)initWithFrame:(CGRect)frame endTime:(NSUInteger)_remaindTime;
@end
