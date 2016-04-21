//
//  RootViewController.m
//  BakeCake
//
//  Created by zhangchong on 8/10/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "ScanViewController.h"
#import "ScanResultViewController.h"

@implementation RootViewController

-(void)navigationBackButton:(id) sender {
    
}

#define TAB_SEL_TOP (SCREEN_HEIGHT-5-TABBAR_HEIGHT)
#define TAB_SEL_WIDTH (SCREEN_WIDTH/5.0)
#define TAB_SEL_HEIGHT 10

#pragma mark -
#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];

    [AppDelegate shareInstance].navController.navigationBarHidden = NO;
    [AppDelegate shareInstance].navController.toolbar.hidden = YES;

    self.title = @"BcupScan";
    
    CGFloat buttonWidth = 300;
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scanBtn.frame = CGRectMake((SCREEN_WIDTH - buttonWidth)/2.0, 200, buttonWidth, 40);
    [scanBtn setTitle:@"扫描 & 查询订单" forState:UIControlStateNormal];
    [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(showScan) forControlEvents:UIControlEventTouchUpInside];
    scanBtn.layer.borderColor = MAIN_COLOR.CGColor;
    scanBtn.layer.cornerRadius = 15;
    scanBtn.backgroundColor = MAIN_COLOR;
    [self.view addSubview:scanBtn];
}


- (void)showScan {
    ScanViewController *scan = [[ScanViewController alloc] init];
    [[AppDelegate shareInstance].navController pushViewController:scan animated:YES];
}

- (void)searchOrder {
    ScanResultViewController *result = [[ScanResultViewController alloc] init];
    [[AppDelegate shareInstance].navController pushViewController:result animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTabBarBg {
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBarController.tabBar.bounds];
    UIImageView *bgviewimg = [[UIImageView alloc] initWithFrame:self.tabBarController.tabBar.bounds];
    bgviewimg.image = [UIImage imageNamed:@"tab-bar-bk-"];
    [bgView addSubview:bgviewimg];
    [self.tabBarController.tabBar insertSubview:bgView atIndex:0];

}

+ (RootViewController *)getShareInstance {
    static dispatch_once_t pred = 0;
    __strong static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
