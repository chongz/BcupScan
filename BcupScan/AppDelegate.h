//
//  AppDelegate.h
//  BcupScan
//
//  Created by zhangchong on 12/10/15.
//  Copyright © 2015 com.infohold. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIWindow               *window;
@property (strong, nonatomic) RootViewController     *rootViewController;
@property (strong, nonatomic) UIImageView            *splashView;
@property (strong, nonatomic) UIImageView            *splashView2;
@property (strong, nonatomic) NSMutableArray         *presentConrollerArray;

+ (AppDelegate *)shareInstance;
- (void)setLeftNavigationBar:(NSString *)title target:(id)target action:(SEL)action;
- (void)setNavigationbar:(NSString *)title target:(id)target action:(SEL) action;
- (void)clearLeftNavButton;
- (void)clearRightNavButton;
- (void)setTitle:(NSString *) title;
- (void)showNavBar;
- (UIViewController *)popPresentedController;
- (void)addPresentController:(UIViewController *)controller;
- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)hiddenNavbar;
- (void)setRightBarButtonInRoot:(UIBarButtonItem *)rightButtonItem;

@end

