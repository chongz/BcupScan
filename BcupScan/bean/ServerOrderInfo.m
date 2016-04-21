//
//  ServerOrderInfo.m
//  BakeCake
//
//  Created by zhangchong on 10/26/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "ServerOrderInfo.h"
#import "NSDictionary+NoneKeyCheck.h"
#import "ResouceManager.h"

@implementation ServerOrderInfo
@synthesize orderID;
@synthesize orderState;
@synthesize orderDetails;
@synthesize orderPhone;
@synthesize orderSource;
@synthesize orderSourceText;
@synthesize orderCity;
@synthesize orderBuyer;
@synthesize orderPay;
@synthesize orderPayText;
@synthesize orderAddress;
@synthesize timeDelivery;
@synthesize timeStart;
@synthesize orderDeliveryFee;
@synthesize orderDeliveryMethod;
@synthesize postCardID;
@synthesize postCardContent;
@synthesize orderPin;
@synthesize orderKind;
@synthesize orderStore;

@synthesize orderAssessArray;
@synthesize orderArray;

- (ServerOrderInfo *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.orderID             = [dic objectAvoidNullKey:@"orderID"];
        self.orderDeliveryMethod = [dic objectAvoidNullKey:@"orderDeliveryMethod"];
        self.orderDeliveryFee    = [dic objectAvoidNullKey:@"orderDeliveryFee"];
        self.orderState          = [dic objectAvoidNullKey:@"orderState"];
        
        NSArray *ordersArray     = [dic objectForKey:@"orderDetails"];//
        self.orderArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *ele in ordersArray) {
            NSString *orderType = [ele objectAvoidNullKey:@"orderType"];
            NSString *productID = [ele objectAvoidNullKey:@"productID"];
            NSString *orderNumber = [ele objectAvoidNullKey:@"orderNumber"];
            if ([productID length] != 0) {
                //喜爱单品，喜爱产品
                if ([@"1" isEqualToString:orderType]) {
                    NSString *cakePid = [ele objectAvoidNullKey:@"cake"];
                    NSString *icingPid = [ele objectAvoidNullKey:@"icing"];
                    NSString *toppingPid = [ele objectAvoidNullKey:@"topping"];
                    if ([toppingPid length] == 0) {
                        toppingPid = @"-1";
                    }
                    
                    NSString *stuffingPid = [ele objectAvoidNullKey:@"stuffing"];
                    
                    if ([stuffingPid length] == 0) {
                        stuffingPid = @"-1";
                    }
           
                    
                    Cake *cake = [[ResouceManager sharedInstance] queryCakeTalbe:cakePid];
                    Icing *icing = [[ResouceManager sharedInstance] queryIcingTalbe:icingPid];
                    Topping *topping = [[ResouceManager sharedInstance] queryToppingTalbe:toppingPid];
                    Stuffing *stuffing = [[ResouceManager sharedInstance] queryStuffingTalbe:stuffingPid];
                    
                    CupCake *cupcake = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];
                    
                    
                    FlavorCupcake *flaovorCupcake = [[ResouceManager sharedInstance] queryShoppingCartFlaovrCupcake:productID];
                    flaovorCupcake.cupcake = cupcake;
                    OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithFlavorCupcake:flaovorCupcake cupcakeNum:[orderNumber integerValue] ];
                    [self.orderArray addObject:orderCupcake];
                    

                    
                    
                }else if([@"0" isEqualToString:orderType]) {
                    //如果数据库中无喜爱的蛋糕产品，增加到数据库
                    FlavorProduct *product = [[ResouceManager sharedInstance] queryShoppingCartFlaovrProduct:productID];
                    OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithFlavorProduct:product cupcakeNum:[orderNumber integerValue]];
                    [self.orderArray addObject:orderCupcake];
                }

            }else{
                //定制单品
                NSString *cakePid    = [ele objectAvoidNullKey:@"cake"];
                NSString *icingPid   = [ele objectAvoidNullKey:@"icing"];
                NSString *toppingPid = [ele objectAvoidNullKey:@"topping"];
                if ([toppingPid length] == 0) {
                    toppingPid = @"-1";
                }
                
                NSString *stuffingPid = [ele objectAvoidNullKey:@"stuffing"];
                
                if ([stuffingPid length] == 0) {
                    stuffingPid = @"-1";
                }
                
                Cake *cake         = [[ResouceManager sharedInstance] queryCakeTalbe:cakePid];
                Icing *icing       = [[ResouceManager sharedInstance] queryIcingTalbe:icingPid];
                Topping *topping   = [[ResouceManager sharedInstance] queryToppingTalbe:toppingPid];
                Stuffing *stuffing = [[ResouceManager sharedInstance] queryStuffingTalbe:stuffingPid];

                CupCake *cupcake   = [[CupCake alloc] initWithCake:cake icing:icing stuffing:stuffing topping:topping];

                OrderCupcake *orderCupcake = [[OrderCupcake alloc] initWithCupcake:cupcake cupcakeNum:[orderNumber integerValue]];
                
                [self.orderArray addObject:orderCupcake];
            }
        }
        
        self.orderPhone      = [dic objectAvoidNullKey:@"orderPhone"];
        self.timeStart       = [dic objectForKey:@"timeStart"];
        self.orderSource     = [dic objectAvoidNullKey:@"orderSource"];
        
        self.orderSourceText = @"";
        if ([@"1" isEqualToString:self.orderSource]) {
            self.orderSourceText = @"苹果APP";
        }else if ([@"2" isEqualToString:self.orderSource]) {
            self.orderSourceText = @"网上商城";
        }else if ([@"3" isEqualToString:self.orderSource]) {
            self.orderSourceText = @"微信平台";
        }else if ([@"4" isEqualToString:self.orderSource]) {
            self.orderSourceText = @"安卓APP";
        }
        
        
        self.orderCity       = [dic objectAvoidNullKey:@"orderCity"];
        self.orderBuyer      = [dic objectAvoidNullKey:@"orderBuyer"];
        self.orderPay        = [dic objectAvoidNullKey:@"orderPay"];
        
        if ([@"1" isEqualToString:self.orderPay]) {
            self.orderPayText = @"现金";
        }else if ([@"2" isEqualToString:self.orderPay]) {
            self.orderPayText = @"微信";
        }else if ([@"3" isEqualToString:self.orderPay]) {
            self.orderPayText = @"支付宝";
        }else if ([@"4" isEqualToString:self.orderPay]) {
            self.orderPayText = @"POS";
        }
        
        self.orderAddress    = [dic objectAvoidNullKey:@"orderAddress"];
        self.timeDelivery    = [dic objectAvoidNullKey:@"timeDelivery"];
        self.postCardID      = [dic objectAvoidNullKey:@"postCardID"];
        self.postCardContent = [dic objectAvoidNullKey:@"postCardContent"];
        self.orderPin        = [dic objectAvoidNullKey:@"orderPin"];
        self.orderKind       = [dic objectAvoidNullKey:@"orderKind"];
        self.orderStore      = [dic objectAvoidNullKey:@"orderStore"];
        
        
        self.orderAssessArray = [[NSMutableArray alloc] init];
        NSArray *assessArray = [dic objectForKey:@"orderAssess"];
        for (NSDictionary *ele in assessArray) {
            NSString *assessContent = [ele objectAvoidNullKey:@"assessContent"];
            [self.orderAssessArray addObject:assessContent];
        }
    }
    return self;
}

- (NSInteger) getProductNum {
    NSInteger totalProductNum = 0;
    for (OrderCupcake *orderCupcake in self.orderArray) {
        totalProductNum += orderCupcake.num; 
    }
    
    return totalProductNum;
}

- (CGFloat)getPrice {
    CGFloat totalPrice = 0.0f;
    for (OrderCupcake *orderCupcake in self.orderArray) {
        totalPrice += [orderCupcake getPrice];
    }
    
    return totalPrice;
}

- (BOOL)isEvalue {
    if ([@"5" isEqualToString:self.orderState] && [self.orderAssessArray count] > 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isPickByUser {
    if ([@"1" isEqualToString:self.orderKind]) {
        return YES;
    }
    
    return NO;
}

@end
