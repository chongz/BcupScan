//
//  CupcakeView.h
//  BakeCake
//
//  Created by zhangchong on 8/20/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ResouceManager.h"
#import "CupCake.h"
@interface CupcakeView : UIView

@property (nonatomic, strong) CupCake *cupcake;
@property (nonatomic, strong) UILabel *cakeLabel;
@property (nonatomic, strong) UILabel *cakeValueLabel;
@property (nonatomic, strong) UILabel *icingLabel;
@property (nonatomic, strong) UILabel *icingValueLabel;
@property (nonatomic, strong) UILabel *toppingLabel;
@property (nonatomic, strong) UILabel *toppingValueLabel;
@property (nonatomic, strong) UILabel *stuffingLabel;
@property (nonatomic, strong) UILabel *stuffingValueLabel;

-(UIView *) initWithCupCake:(CupCake *)cupcake;
- (void) createSubView;
@end
