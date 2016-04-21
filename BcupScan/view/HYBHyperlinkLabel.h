//
//  HYBHyperlinkLabel.h
//  BakeCake
//
//  Created by zhangchong on 9/8/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @brief 定制超链接标签，也就是上面是文字，下面是一条横线，可以指定颜色值，默认是蓝色，
 *        下划线会处在文字的正下方，宽度会根据文字自动调整，字体大小默认是13号字
 * @note  仅适用于单行超链接
 * @author huangyibiao
 */
@interface HYBHyperlinkLabel : UIView

@property (nonatomic, strong) UIColor *textColor;// 文本颜色，默认是[UIColor blueColor]
@property (nonatomic, strong) UIColor *underlineColor;// 下划线颜色，默认是[UIColor blueColor]

- (id)initWithFrame:(CGRect)frame text:(NSString *)text;
- (id)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font;

- (id)initWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor;
- (id)initWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

- (id)initWithFrame:(CGRect)frame
               text:(NSString *)text
          textColor:(UIColor *)textColor
     underlineColor:(UIColor *)underlineColor;
- (id)initWithFrame:(CGRect)frame
               text:(NSString *)text
          textColor:(UIColor *)textColor
     underlineColor:(UIColor *)underlineColor
               font:(UIFont *)font;

// 如果需要在点击超链接的时候，可以处理响应，那么需要调用此方法来指定回调
- (void)addTarget:(id)target action:(SEL)action;

@end