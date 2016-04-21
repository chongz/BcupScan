//
//  NormalBaseViewController.m
//  BakeCake
//
//  Created by zhangchong on 10/17/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "NormalBaseViewController.h"
#import "ResouceManager.h"
#import "Constants.h"

@interface NormalBaseViewController ()

@end

@implementation NormalBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImg.image = [UIImage imageNamed:@"bg-@2x"];
    [self.view addSubview:backImg];
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
