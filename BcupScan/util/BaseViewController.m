//
//  BaseViewController.m
//  BakeCake
//
//  Created by zhangchong on 9/7/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ResouceManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImg.image = [UIImage imageNamed:@"bg-@2x"];
    [self.view addSubview:backImg];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[AppDelegate shareInstance] clearRightNavButton];
    LOG_METHOD_LEAVE();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
