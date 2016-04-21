//
//  CupcakePicView.h
//  BakeCake
//
//  Created by zhangchong on 8/25/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "ResouceManager.h"
#import "Cake.h"
#import "Icing.h"
#import "Topping.h"
#import "Stuffing.h"
#import "CupCake.h"

@interface CupcakePicView : UIView

@property (nonatomic, strong) UIImageView  *cakeImageView;
@property (nonatomic, strong) UIImageView  *icingImageView;
@property (nonatomic, strong) UIImageView  *toppingImageView;
@property (nonatomic, strong) UIImageView  *stuffingImageView;
@property (nonatomic, strong) CupCake       *cupcake;
@property (nonatomic, assign) PIC_LOOK_TYPE lookType;

-(CupcakePicView *) initWithCupcake:(CupCake *)cupcake lookType:(PIC_LOOK_TYPE)looktype;
- (void)createView;
- (void)updateCupcakeView:(CupCake *) cc;
- (void)updateCupcakeCutOverView:(CupCake *) cc;

- (void)updateCakeCutOverView:(Cake *)cake;
- (void)updateIcingCutOverView:(Icing *)icing;
- (void)updateToppingCutOverView:(Topping *)topping;
- (void)updateStuffingCutOverView:(Stuffing *)stuffing;

- (void)updateCupcakeOverlookView:(CupCake *)cc;
- (void)updateCakeOverlookView:(Cake *)cake;
- (void)updateIcingOverlookView:(Icing *)icing;
- (void)updateToppingOverlookView:(Topping *)topping;

- (void)updateCupcakeCutOverFrontView:(CupCake *) cc;
- (void)updateCakeCutOverFrontView:(Cake *)cake;
- (void)updateIcingCutOverFrontView:(Icing *)icing;
- (void)updateToppingCutOverFrontView:(Topping *)topping;
@end
