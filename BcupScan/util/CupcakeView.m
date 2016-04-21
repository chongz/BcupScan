//
//  CupcakeView.m
//  BakeCake
//
//  Created by zhangchong on 8/20/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "CupcakeView.h"
#import "Constants.h"
#import "Cake.h"
#import "Icing.h"
#import "Topping.h"
#import "Stuffing.h"



#define HEIGHT_SPACE 25

#define LABEL_COLOR [UIColor blackColor]
#define LABEL_VALUE_COLOR [UIColor colorWithRed:0.866 green:0.129 blue:0.337 alpha:1]



@implementation CupcakeView
@synthesize cakeLabel;
@synthesize cakeValueLabel;
@synthesize icingLabel;
@synthesize icingValueLabel;
@synthesize toppingLabel;
@synthesize toppingValueLabel;
@synthesize stuffingLabel;
@synthesize stuffingValueLabel;
@synthesize cupcake;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    [self createSubView];
}

-(UIView *) init:(NSString *)cakeName  icingName:(NSString *) icingName toppingName:(NSString *)toppingName stuffingName:(NSString *) stuffingName {
    
    self = [super init];
    [self initComonent:cakeName icingName:icingName toppingName:toppingName stuffingName:stuffingName];
    
    return self;
}

-(UIView *) initWithCupCake:(CupCake *)_cupcake {
    
    self = [super init];
    if (self) {
        self.cupcake = _cupcake;
        //使用drawRect设置透明为no
        self.opaque = NO;
    }
 
    return self;
}

//文字页面为材料的名字
- (void) createSubView {
    Cake *cake = cupcake.cake;
    NSString *cakeName = nil;
    if (cake != nil) {
        cakeName = cake.materialName;
    }
    
    Icing *icing = cupcake.icing;
    NSString *icingName = nil;
    if (icing != nil) {
        icingName = icing.materialName;
    }
    
    Topping *topping = cupcake.topping;
    NSString *toppingName = nil;
    if (topping !=nil && ![topping.pid isEqualToString:kDefaultToppingId]) {
        toppingName = topping.materialName;
    }
    
    Stuffing *stuffing = cupcake.stuffing;
    NSString *stuffingName = nil;
    if (stuffing != nil && ![stuffing.pid isEqualToString:kDefaultStuffingId]) {
        stuffingName = stuffing.materialName;
    }

    [self initComonent:cakeName icingName:icingName toppingName:toppingName stuffingName:stuffingName];
}

-(void) initComonent:(NSString *)cakeName  icingName:(NSString *) icingName toppingName:(NSString *)toppingName stuffingName:(NSString *) stuffingName{
    ResouceManager *resouceManager = [ResouceManager sharedInstance];
    
    CGFloat posY = 0;
    CGFloat posX = 0;

    CGFloat componentLabelWidth = CGRectGetWidth(self.bounds)/2.0 - 10;
    CGFloat componentValueLabelWidth = CGRectGetWidth(self.bounds)/2.0;
    CGFloat componentHeight = 25;
    
    UIColor *colorValue = [UIColor colorWithRed:0xE5/255.0 green:0x1B/255.0 blue:0x54/255.0 alpha:1];
    UIColor *colorLabel = [UIColor colorWithRed:0x04/255.0 green:0 blue:0 alpha:1];
    UIFont *font = [UIFont systemFontOfSize:14];
    if (cakeName != nil) {
        cakeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, componentLabelWidth, componentHeight)];
        [cakeLabel setText:[resouceManager getResouceValue:@"Cake"]];
        [cakeLabel setTextAlignment:NSTextAlignmentRight];
        [cakeLabel setTextColor:colorLabel];
        [cakeLabel setFont:font];
        [self addSubview:cakeLabel];
        
        
        cakeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(componentValueLabelWidth, posY, componentValueLabelWidth, componentHeight)];
        [cakeValueLabel setTextAlignment:NSTextAlignmentLeft];
        [cakeValueLabel setText:cakeName];
        [cakeValueLabel setTextColor:colorValue];
        [cakeValueLabel setFont:font];
        [self addSubview:cakeValueLabel];
        
    }
    
    if (icingName != nil) {
        
        posY += componentHeight;
        icingLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, componentLabelWidth, componentHeight)];
        [icingLabel setText:[resouceManager getResouceValue:@"Icing"]];
        [icingLabel setTextAlignment:NSTextAlignmentRight];
        [icingLabel setTextColor:colorLabel];
        [icingLabel setFont:font];
        [self addSubview:icingLabel];
        

        icingValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(componentValueLabelWidth, posY, componentValueLabelWidth, componentHeight)];
        [icingValueLabel setTextAlignment:NSTextAlignmentLeft];
        [icingValueLabel setText:icingName];
        [icingValueLabel setTextColor:colorValue];
        [icingValueLabel setFont:font];
        [self addSubview:icingValueLabel];
    }
    
    
    
    if (toppingName != nil && [toppingName length] > 0) {

        posY += componentHeight;
        
        toppingLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, componentLabelWidth, componentHeight)];
        [toppingLabel setText:[resouceManager getResouceValue:@"Topping"]];
        [toppingLabel setTextAlignment:NSTextAlignmentRight];
        [toppingLabel setTextColor:colorLabel];
        [toppingLabel setFont:font];
        [self addSubview:toppingLabel];
        
        toppingValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(componentValueLabelWidth, posY, componentValueLabelWidth, componentHeight)];
        [toppingValueLabel setTextAlignment:NSTextAlignmentLeft];
        [toppingValueLabel setText:toppingName];
        [toppingValueLabel setTextColor:colorValue];
        [toppingValueLabel setFont:font];
        [self addSubview:toppingValueLabel];

    }
    
    if (stuffingName != nil && [stuffingName length] > 0) {

        posY += componentHeight;
        stuffingLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, componentLabelWidth, componentHeight)];
        [stuffingLabel setText:[resouceManager getResouceValue:@"Stuffing"]];
        [stuffingLabel setTextAlignment:NSTextAlignmentRight];
        [stuffingLabel setTextColor:colorLabel];
        [stuffingLabel setFont:font];
        [self addSubview:stuffingLabel];

        stuffingValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(componentValueLabelWidth, posY, componentValueLabelWidth, componentHeight)];
        [stuffingValueLabel setTextAlignment:NSTextAlignmentLeft];
        [stuffingValueLabel setText:stuffingName];
        [stuffingValueLabel setTextColor:colorValue];
        [stuffingValueLabel setFont:font];
        [self addSubview:stuffingValueLabel];
    }
    
}

-(void) loadCupcake:(CupCake *) oneCupcake {
    Cake *cake = oneCupcake.cake;
    
    
    NSString *cakeName = @"";
    if (cake != nil) {
        cakeName = cake.materialName;
    }
    
    Icing *icing = oneCupcake.icing;
    NSString *icingName = @"";
    if (icing != nil) {
        icingName = icing.materialName;
    }
    
    
    Topping *topping = oneCupcake.topping;
    NSString *toppingName = @"";
    if (topping != nil) {
        toppingName = topping.materialName;
    }
    
    Stuffing *stuffing = oneCupcake.stuffing;
    NSString *stuffingName = @"";
    if (stuffing != nil) {
        stuffingName = stuffing.materialName;
    }
    
    [self loadComonent:cakeName icingName:icingName toppingName:toppingName stuffingName:stuffingName];
}

-(void) loadComonent:(NSString *)cakeName  icingName:(NSString *) icingName toppingName:(NSString *)toppingName stuffingName:(NSString *) stuffingName{
    
}
@end
