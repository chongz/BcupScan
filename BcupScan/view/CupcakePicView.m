//
//  CupcakePicView.m
//  BakeCake
//
//  Created by zhangchong on 8/25/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "CupcakePicView.h"
#import "UIImageView+WebCache.h"

@implementation CupcakePicView
@synthesize cakeImageView;
@synthesize icingImageView;
@synthesize toppingImageView;
@synthesize stuffingImageView;
@synthesize cupcake;
@synthesize lookType;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self createView];
}


- (CupcakePicView *)initWithCupcake:(CupCake *)acupcake lookType:(PIC_LOOK_TYPE)looktype{
    self = [super init];
    
    if (self) {
        self.cupcake = acupcake;
        self.opaque = NO;
        self.lookType = looktype;
        
        self.cakeImageView     = [[UIImageView alloc] init];
        self.icingImageView    = [[UIImageView alloc] init];
        self.toppingImageView  = [[UIImageView alloc] init];
        self.stuffingImageView = [[UIImageView alloc] init];
    }
    return self;
}


- (void)createView {
    if (self.lookType == PIC_OVER_LOOK) {
        [self createOverlookView];
    }else if(self.lookType == PIC_CUT_OVER_LOOK){
        [self createCutoverView];
    }else if(self.lookType == PIC_CUT_OVER_LOOK2) {
        [self createCutoverFrontView];
    }
}

- (void)updateCupcakeView:(CupCake *) cc {
    if (self.lookType == PIC_CUT_OVER_LOOK) {
        [self updateCupcakeCutOverView:cc];
    }else if(self.lookType == PIC_OVER_LOOK){
        [self updateCupcakeOverlookView:cc];
    }else {
        [self updateCupcakeCutOverFrontView:cc];
    }
}

#pragma mark -
#pragma mark 切面图
- (void)createCutoverView {
    //蛋糕体
    [cakeImageView setFrame:self.bounds];
    if (self.cupcake.cake) {
        [self updateCakeCutOverView:self.cupcake.cake];
    }
    [self addSubview:cakeImageView];
    
    //奶油
    [icingImageView setFrame:self.bounds];
    if (self.cupcake.icing) {
        [self updateIcingCutOverView:self.cupcake.icing];
    }
    [self addSubview:icingImageView];
    
    
    //装饰
    [toppingImageView setFrame:self.bounds];
    if (self.cupcake.topping) {
        [self updateToppingCutOverView:self.cupcake.topping];
    }
    [self addSubview:toppingImageView];

    //内陷
    [stuffingImageView setFrame:self.bounds];
    if (self.cupcake.stuffing) {
        [self updateStuffingCutOverView:self.cupcake.stuffing];
    }
    
    [stuffingImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:stuffingImageView];
    
    
}

- (void)updateCupcakeCutOverView:(CupCake *) cc {
    
    if (cc.cake != nil) {
        [self updateCakeCutOverView:cc.cake];
    }
    
    if (cc.icing != nil) {
        [self updateIcingCutOverView:cc.icing];
    }
    
    if (cc.topping != nil) {
        [self updateToppingCutOverView:cc.topping];
    }
    
    if (cc.stuffing != nil) {
        [self updateStuffingCutOverView:cc.stuffing];
    }
}

- (void)updateCakeCutOverView:(Cake *)cake {

    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_CAKE_PATH,cake.cutOverPicName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath ]) {
        cakeImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [cakeImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:cake.cutOverPicServerName]];
    }
}

- (void)updateIcingCutOverView:(Icing *)icing {

    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_ICING_PATH,icing.cutOverPicName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        icingImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else {
        [icingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:icing.cutOverPicServerName]];
    }
}

- (void)updateToppingCutOverView:(Topping *)topping {

    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_TOPPING_PATH,topping.cutOverPicName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        toppingImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else {
        [toppingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:topping.cutOverPicServerName]];
    }
}

- (void)updateStuffingCutOverView:(Stuffing *)stuffing {

    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_STUFFING_PATH,stuffing.cutOverPicName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        stuffingImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [stuffingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:stuffing.cutOverPicServerName]];
    }
}

#pragma mark -
#pragma mark 切面-front图
-(void) createCutoverFrontView {
    //蛋糕体
    [cakeImageView setFrame:self.bounds];
    if (self.cupcake.cake) {
        [self updateCakeCutOverFrontView:self.cupcake.cake];
    }
    [self addSubview:cakeImageView];

    //奶油
    [icingImageView setFrame:self.bounds];
    if (self.cupcake.icing) {
        [self updateIcingCutOverFrontView:self.cupcake.icing];
    }
    [self addSubview:icingImageView];
    
    //装饰
    [toppingImageView setFrame:self.bounds];
    if (self.cupcake.topping) {
        [self updateToppingCutOverFrontView:self.cupcake.topping];
    }
    [self addSubview:toppingImageView];
}

- (void)updateCupcakeCutOverFrontView:(CupCake *) cc {
    
    if (cc.cake != nil) {
        [self updateCakeCutOverFrontView:cc.cake];
    }
    
    if (cc.icing != nil) {
        [self updateIcingCutOverFrontView:cc.icing];
    }
    
    if (cc.topping != nil) {
        if ([@"-1" isEqualToString:cc.topping.pid]) {
            [self updateToppingCutOverFrontViewNoTopping];
        }else {
            [self updateToppingCutOverFrontView:cc.topping];
        }
    }
    
}

- (void)updateCakeCutOverFrontView:(Cake *)cake {

    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_CAKE_OVERLOOK_FRONT_PATH,cake.overLookFrontPicName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        cakeImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [cakeImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:cake.overLookFrontPicServerName]];
    }
}

- (void)updateIcingCutOverFrontView:(Icing *)icing {
    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_ICING_OVERLOOK_FRONT_PATH,icing.overLookFrontPicName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        icingImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [icingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:icing.overLookFrontPicServerName]];
    }
}

- (void)updateToppingCutOverFrontView:(Topping *)topping {
    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],kIMG_LOCAL_TOPPING_OVERLOOK_FRONT_PATH,topping.overLookFrontPicName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        toppingImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [stuffingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:topping.overLookFrontPicServerName]];
    }
    
}

- (void)updateToppingCutOverFrontViewNoTopping {
    toppingImageView.image = nil;
}


#pragma mark -
#pragma mark 俯视图
- (void)createOverlookView {
    
    //蛋糕体
    cakeImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    if (self.cupcake.cake) {
        [cakeImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:self.cupcake.cake.overLookPicServerName]];
    }

    [self addSubview:cakeImageView];
    
    
    //奶油
    icingImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    if (self.cupcake.icing) {
        [icingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:self.cupcake.icing.overLookPicServerName]];
    }
    
    [self addSubview:icingImageView];
    
    //装饰
    toppingImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    if (self.cupcake.topping) {
        [toppingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:self.cupcake.topping.overLookPicServerName]];
    }
    
    [self addSubview:toppingImageView];
}


- (void)updateCupcakeOverlookView:(CupCake *)cc {
    if (cc.cake != nil) {
        [self updateCakeOverlookView:cc.cake];
    }
    
    if (cc.icing != nil) {
        [self updateIcingOverlookView:cc.icing];
    }
    
    if (cc.topping != nil) {
        [self updateToppingOverlookView:cc.topping];
    }
}

- (void)updateCakeOverlookView:(Cake *)cake {

    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],
                              kIMG_LOCAL_CAKE_OVERLOOK_PATH,
                              cake.overLookPicName
                              ];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        cakeImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [cakeImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:cake.overLookPicServerName]];
    }

}

- (void)updateIcingOverlookView:(Icing *)icing {
    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],
                              kIMG_LOCAL_ICING_OVERLOOK_PATH,
                              icing.overLookPicName
                              ];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        icingImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [icingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:icing.overLookPicServerName]];
    }
}

- (void)updateToppingOverlookView:(Topping *)topping {

    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",[ResouceManager doucmentPath],
                              kIMG_LOCAL_TOPPING_OVERLOOK_PATH,
                              topping.overLookPicName
                              ];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        toppingImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        [toppingImageView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:topping.overLookPicServerName]];
    }
}

@end
