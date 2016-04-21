//
//  RootViewController.h
//  BakeCake
//
//  Created by zhangchong on 8/10/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ResouceManager.h"

@interface RootViewController : UIViewController<UITabBarControllerDelegate>
//@property (nonatomic, strong) UITabBarController          *tabBarController;
//@property (nonatomic, strong) UIImageView                 *tabarSelImgView;
+ (RootViewController *)getShareInstance;
//- (void)didSelected:(CTL_SELECTED )ctrSelect;
@end

