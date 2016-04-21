//
//  AppDelegate.m
//  BcupScan
//
//  Created by zhangchong on 12/10/15.
//  Copyright © 2015 com.infohold. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ResouceManager.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize rootViewController;
@synthesize navController;
@synthesize splashView;
@synthesize splashView2;
@synthesize presentConrollerArray;

//注册分享，版本要支持新浪微博、QQ好友和QQ空间、微信
#define shareAppKey @"b2520a0c821c"
#define shareAppSecret @"ab35e5fbbdb8ef1392defaa46977da97"
//注册短信
#define appKey @"b254842c365d"
#define appSecret @"acd75a4aff2e78c8eb273c044831d639"


- (void)initNavBar {
    
    //定义导航背景图片
    UIImage *navBackgroundImg = [UIImage imageNamed:@"nav-bg-"];
    [self.navController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:navBackgroundImg]];
    
    //定义返回按钮，返回文字，left，rightBarItem颜色
    [self.navController.navigationBar setTintColor:MAIN_COLOR];
    
    //设置title文字大小，颜色
    [self.navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    presentConrollerArray = [[NSMutableArray alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.rootViewController = [[RootViewController alloc] init];
    self.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.navController = [[UINavigationController alloc] init];
    [self.navController setNavigationBarHidden:YES];
    [self initNavBar];
    
    
    [self.window makeKeyAndVisible];
    [self performSelectorInBackground:@selector(loadResource) withObject:nil];
    
    
    [self animationInit];
    [self performSelector:@selector(animation1) withObject:nil afterDelay:0];
    [self performSelector:@selector(animation2) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(animation3) withObject:nil afterDelay:2];
    
    [self.window setRootViewController:self.navController];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    return YES;
}

#pragma mark -
#pragma mark 动画
- (void)animationInit {
    CGFloat logo1Top = 354/2;
    CGFloat logo1Width = 292/2;
    CGFloat logo1Height = 293/2.0;
    CGFloat splashLeft = 229/2.0;
    CGRect splashViewRect = CGRectMake(splashLeft, logo1Top, logo1Width, logo1Height);
    
    if (IS_IPHONE_4_OR_LESS) {
        logo1Top = 252/2;
        logo1Width = 247/2.0;
        logo1Height = 248/2;
        splashLeft = 195/2.0;
        splashViewRect = CGRectMake(splashLeft, logo1Top, logo1Width, logo1Height);
    }else if (IS_IPHONE_5) {
        logo1Width = 247/2.0;
        logo1Height = 248/2.0;
        splashLeft = 196/2;
        splashViewRect = CGRectMake(splashLeft, 332/2, logo1Width, logo1Height);
    }else if(IS_IPHONE_6_S_P){
        splashViewRect = CGRectMake(splashLeft * IP6_TO_IP6SP_SCALE, logo1Top * IP6_TO_IP6SP_SCALE, logo1Width * IP6_TO_IP6SP_SCALE, logo1Height * IP6_TO_IP6SP_SCALE);
    }
    
    splashView = [[UIImageView alloc] initWithFrame:splashViewRect];
    splashView.image = [UIImage imageNamed:@"img-1-logo-"];
    [self.window addSubview:splashView];
    
    
    CGFloat splash2Width = 129/2.0;
    CGFloat splash2Height = 114/2;
    CGFloat splash2Left = 314/2;
    CGRect splash2ViewRect = CGRectMake(splash2Left, SCREEN_HEIGHT-132, splash2Width, splash2Height);
    
    if (IS_IPHONE_4_OR_LESS) {
        splash2Width = 112/2;
        splash2Height = 99/2.0;
        splash2Left = 264/2;
        CGFloat splash2Top = SCREEN_HEIGHT - 87/2 - 99/2.0;
        splash2ViewRect = CGRectMake(splash2Left, splash2Top, splash2Width, splash2Height);
    }else if (IS_IPHONE_5) {
        splash2Width = 112/2;
        splash2Height = 99/2.0;
        splash2Left = 264/2;
        CGFloat splash2Top = SCREEN_HEIGHT - 106/2 - 99/2.0;
        splash2ViewRect = CGRectMake(splash2Left, splash2Top, splash2Width, splash2Height);
    }else if (IS_IPHONE_6_S_P) {
        CGFloat splash2Top = SCREEN_HEIGHT-(132/2 + 114/2)* IP6_TO_IP6SP_SCALE;
        splash2ViewRect = CGRectMake(splash2Left, splash2Top , splash2Width * IP6_TO_IP6SP_SCALE, splash2Height * IP6_TO_IP6SP_SCALE);
    }else{
        
    }
    
    
    splashView2 = [[UIImageView alloc] initWithFrame:splash2ViewRect];
    splashView2.image = [UIImage imageNamed:@"img-header-logo-"];
    [self.window addSubview:splashView2];
}

- (void)animation1 {
    [UIView animateWithDuration:1.0 animations:^{
        CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1.0);
        splashView.layer.transform = transform;
        splashView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animation2 {
    CGFloat left = 126/2;
    CGFloat top = 331/2.0;
    CGFloat width = 471/2.0;
    CGFloat height = 375/2.0;
    CGRect rect2 = CGRectMake(left, top, width, height);
    
    if (IS_IPHONE_4_OR_LESS) {
        left = 116/2;
        top = 224/2;
        width = 408/2;
        height = 325/2.0;
        rect2 = CGRectMake(left, top, width, height);
    }else if (IS_IPHONE_5) {
        left = 113/2.0;
        top = 307/2.0;
        width = 408/2;
        height = 325/2.0;
        rect2 = CGRectMake(left, top, width, height);
    }else if (IS_IPHONE_6_S_P) {
        rect2 = CGRectMake(left * IP6_TO_IP6SP_SCALE , top * IP6_TO_IP6SP_SCALE, width * IP6_TO_IP6SP_SCALE, height * IP6_TO_IP6SP_SCALE);
    }
    
    splashView.alpha = 1.0;
    splashView.frame = rect2;
    [UIView animateWithDuration:1.0 animations:^{
        splashView.image = [UIImage imageNamed:@"img-2-logo-"];
    } completion:^(BOOL finished) {
    }];
}

- (void)animation3 {
    [UIView animateWithDuration:1.0 animations:^{
        splashView.alpha = 0;
        splashView2.alpha = 0;
        
        CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1.0);
        splashView.layer.transform = transform;
    } completion:^(BOOL finished) {
        [splashView removeFromSuperview];
        [splashView2 removeFromSuperview];
        [self.navController pushViewController:rootViewController animated:YES];
    }];
}

- (UIViewController *)popPresentedController {
    if ([presentConrollerArray count] > 0) {
        UIViewController *ctl = [presentConrollerArray lastObject];
        [presentConrollerArray removeObject:ctl];
        return ctl;
    }
    
    return nil;
}

- (void)addPresentController:(UIViewController *)controller {
    [presentConrollerArray addObject:controller];
}

- (void)loadResource {
    
    if (isRelease) {
        [[ResouceManager sharedInstance] downloadCupcakeResource:1 downloadPic:NO showUI:NO inVC:nil pageNo:1 cityId:nil pageSize:10];
    }else{
        [[ResouceManager sharedInstance] downloadCupcakeResource:1 downloadPic:YES showUI:NO inVC:nil pageNo:1 cityId:nil pageSize:10];
    }
    
    [[ResouceManager sharedInstance] downloadFlavorProduct];
    [[ResouceManager sharedInstance] requestDeliverCity];
    [[ResouceManager sharedInstance] requestArgument:3];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[ResouceManager sharedInstance] downloadCupcakeResource:1 downloadPic:NO showUI:NO inVC:nil pageNo:1 cityId:nil pageSize:10];
    [[ResouceManager sharedInstance] requestDeliverCity];
    [[ResouceManager sharedInstance] requestArgument:3];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[ResouceManager sharedInstance] closeDb];
}

+ (AppDelegate *) shareInstance {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)setNavigationbar:(NSString *)title target:(id)target action:(SEL) action {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.rootViewController.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setRightBarButtonInRoot:(UIBarButtonItem *)rightButtonItem {
    self.rootViewController.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setLeftNavigationBar:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.rootViewController.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)clearRightNavButton {
    self.rootViewController.navigationItem.rightBarButtonItem = nil;
    
}

- (void)clearLeftNavButton {
    self.rootViewController.navigationItem.leftBarButtonItem = nil;
}

- (void)setTitle:(NSString *) title {
    rootViewController.title = title;
}

- (void)showNavBar {
    self.navController.navigationBarHidden = NO;
}

- (void)hiddenNavbar {
    self.navController.navigationBarHidden = YES;
}

- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    self.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self.rootViewController presentViewController:viewController animated:animated completion:^{
        self.rootViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        viewController.view.backgroundColor = [UIColor clearColor];
    }];
}

@end
