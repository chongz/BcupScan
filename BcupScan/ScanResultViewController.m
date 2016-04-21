//
//  ScanResultViewController.m
//  BcupScan
//
//  Created by zhangchong on 12/11/15.
//  Copyright © 2015 com.infohold. All rights reserved.
//

#import "ScanResultViewController.h"
#import "Constants.h"
#import "ResouceManager.h"
#import "ProgressHUD.h"
#import "ServerOrderInfo.h"
#import "CupcakePicView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define pageSize 10

@interface ScanResultViewController ()

@end

@implementation ScanResultViewController
@synthesize contentView;
@synthesize topSpace;
@synthesize leftSpace;
@synthesize labelHeight;
@synthesize orderId;
@synthesize memberPhone;
@synthesize qrcode;
- (instancetype)initWithQRcodeText:(NSString *)qrcodeText {
    self = [super init];
    if (self) {
        NSArray *contentArray = [qrcodeText componentsSeparatedByString:@","];
        if (contentArray != nil && [contentArray count] == 2) {
            self.memberPhone = [contentArray objectAtIndex:0];
            self.orderId = [contentArray objectAtIndex:1];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"扫描订单详情";
    contentView = [[UIScrollView alloc] init];
    contentView.delegate = self;
    contentView.showsVerticalScrollIndicator = YES;
    contentView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    contentView.showsHorizontalScrollIndicator = NO;
    [self requestOrderInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LOG(@"scan result viewWillAppear");
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LOG(@"scan result did apear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestOrderInfo {
    if (![ResouceManager isExistenceNetwork]) {
        return;
    }
    
    if (![ResouceManager isExistenceBcupService]) {
        return;
    }
    
    if (self.memberPhone == nil || [self.memberPhone length] == 0) {
        return;
    }
    
    if (self.orderId == nil || [self.orderId length] == 0) {
        return;
    }
    
    [[ResouceManager sharedInstance] startLoading];
    [ProgressHUD show:@"订单查询中" Interaction:YES];
    NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
    [req setObject:self.memberPhone forKey:@"memberID"];
    [req setObject:self.orderId forKey:@"orderID"];
    
    LOG(@"req======>%@",req);
    
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:SMART_SERVICE_ENDPOINT]];
    
    [client invokeMethod:@"getOrderList"
          withParameters:@[req]
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [self dealwithData:responseObject];
                     [[ResouceManager sharedInstance] finishLoading];
                     [ProgressHUD dismiss];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [ProgressHUD showError:@"订单查询失败"];
                     [[ResouceManager sharedInstance] finishLoading];
                     
                 }];
}

- (void)dealwithData:(id)responseObject {
    LOG(@"%@",responseObject);
    if (responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSString *repCode = [dic objectAvoidNullKey:@"repCode"];
        NSString *totalNum = [dic objectForKey:@"totalNum"];
        NSString *repMSG = [dic objectAvoidNullKey:@"repMSG"];
        
        
        if (totalNum != nil && [totalNum length] > 0) {
//            NSUInteger totalOrderNum = [totalNum integerValue];
        }
        
        
        if ([REQUEST_SUCCESS isEqualToString:repCode]) {
            NSString *repData = [dic objectAvoidNullKey:@"repData"];
            NSData *jsonData = [repData dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *list = [jsonData objectFromJSONData];
            
            if ([list count] == 0) {
                [ProgressHUD showSuccess:@"不是本店订单"];
                return;
            }
            
            NSDictionary *dic = [list objectAtIndex:0];
            ServerOrderInfo *serverOrderInfo = [[ServerOrderInfo alloc] initWithDic:dic];
            [self initView:serverOrderInfo];
        }else{
            [ProgressHUD showError:repMSG];
        }
    }
}

- (NSString *)getOrderStatus:(ServerOrderInfo *)serverInfo {
    NSString *ret = @"";
    
    
    if ([@"1" isEqualToString:serverInfo.orderState]) {
        ret = [[ResouceManager sharedInstance] getResouceValue:@"OrderPay"];
    }else if ([@"2" isEqualToString:serverInfo.orderState]) {
        ret = [[ResouceManager sharedInstance] getResouceValue:@"OrderSend"];
    }else if ([@"3" isEqualToString:serverInfo.orderState]) {
        ret = [[ResouceManager sharedInstance] getResouceValue:@"OrderReceive"];
    }else if ([@"4" isEqualToString:serverInfo.orderState]) {
        ret = [[ResouceManager sharedInstance] getResouceValue:@"OrderReceive"];
    }else if ([@"5" isEqualToString:serverInfo.orderState]) {
        ret = [[ResouceManager sharedInstance] getResouceValue:@"OrderEvaluate"];
    }else if ([@"6" isEqualToString:serverInfo.orderState]) {
        ret = [[ResouceManager sharedInstance] getResouceValue:@"OrderEvaluateDone"];
    }
    
    return ret;
}

#define detailTxtFontSize 11
#define TEXT_COLOR ([UIColor colorWithRed:0x23/255.0 green:0x18/255.0 blue:0x15/255.0 alpha:1])

- (void)initView:(ServerOrderInfo *)serverInfo {
    
     topSpace  = SYSTEM_BAR_HEIGHT + NAVBAR_HEIGHT + 40;
     leftSpace = 46/2.0;
     labelHeight = 30;
    
    if (IS_IPHONE_5) {
        leftSpace = 38/2.0;
    }
    
    CGFloat currentHeight = topSpace;
   
    //订单编号
    CGRect orderIdLabelRect = CGRectMake(leftSpace, currentHeight, 200, labelHeight);
    UILabel *orderIdLabel = [[UILabel alloc] initWithFrame:orderIdLabelRect];
    NSString *orderText = @"订单编号:";
    orderText = [orderText stringByAppendingString:serverInfo.orderID];
    orderIdLabel.text = orderText;
    orderIdLabel.textAlignment = NSTextAlignmentLeft;
    orderIdLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:orderIdLabel];
    
    //订单状态
    CGRect orderStatusLabelRect = CGRectMake(SCREEN_WIDTH - leftSpace - 100  , currentHeight, 100, labelHeight);
    UILabel *orderStatusLabel = [[UILabel alloc] initWithFrame:orderStatusLabelRect];
    orderStatusLabel.text = [self getOrderStatus:serverInfo];
    orderStatusLabel.textAlignment = NSTextAlignmentRight;
    orderStatusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:orderStatusLabel];
    
    
    currentHeight += labelHeight + 5;
    //订单类型
    CGRect orderTypeRect = CGRectMake(leftSpace, currentHeight, 200, labelHeight);
    UILabel *orderTypeLabel = [[UILabel alloc] initWithFrame:orderTypeRect];
    
    if ([@"1" isEqualToString:serverInfo.orderKind]) {
        orderTypeLabel.text = @"订单类型:店内自提";
    }else if([@"2" isEqualToString:serverInfo.orderKind]) {
        orderTypeLabel.text = @"订单类型:送货上门";
    }
    
    orderTypeLabel.textAlignment = NSTextAlignmentLeft;
    orderTypeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:orderTypeLabel];
    
    //验证码
    CGRect qrcodeLabelRect = CGRectMake(SCREEN_WIDTH-leftSpace - 100  , currentHeight, 100, labelHeight);
    UILabel *qrcodeLabel = [[UILabel alloc] initWithFrame:qrcodeLabelRect];
    qrcodeLabel.text = [@"验证码:" stringByAppendingString:serverInfo.orderPin];
    qrcodeLabel.textAlignment = NSTextAlignmentRight;
    qrcodeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:qrcodeLabel];
    
    currentHeight += labelHeight + 5;
    
    //买家
    CGRect buyerLabelRect = CGRectMake(leftSpace, currentHeight, 200, labelHeight);
    UILabel *buyerLabel = [[UILabel alloc] initWithFrame:buyerLabelRect];
    buyerLabel.text = [@"买家:" stringByAppendingString:serverInfo.orderBuyer];
    buyerLabel.textAlignment = NSTextAlignmentLeft;
    buyerLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:buyerLabel];
    
    //联系电话
    CGRect contractLabelRect = CGRectMake(SCREEN_WIDTH - 200 - leftSpace , currentHeight, 200, labelHeight);
    UILabel *contractLabel = [[UILabel alloc] initWithFrame:contractLabelRect];
    

    contractLabel.text = [@"联系电话:" stringByAppendingString:serverInfo.orderPhone];
    contractLabel.textAlignment = NSTextAlignmentRight;
    contractLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:contractLabel];
    
    currentHeight += labelHeight + 5;
    
    //店铺名称
    CGRect storeLabelRect = CGRectMake(leftSpace, currentHeight, 200, labelHeight);
    UILabel *storeLabel = [[UILabel alloc] initWithFrame:storeLabelRect];
    storeLabel.text = [@"店铺名称:" stringByAppendingString:serverInfo.orderStore];
    storeLabel.textAlignment = NSTextAlignmentLeft;
    storeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:storeLabel];
    
    //支付渠道
    CGRect payWayLabelRect = CGRectMake(SCREEN_WIDTH - leftSpace - 100 , currentHeight, 100, labelHeight);
    UILabel *payWayLabel = [[UILabel alloc] initWithFrame:payWayLabelRect];
    
    payWayLabel.text = [@"支付渠道:" stringByAppendingString:serverInfo.orderPayText];
    payWayLabel.textAlignment = NSTextAlignmentRight;
    payWayLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:payWayLabel];
    
    currentHeight += labelHeight + 5;
    //渠道来源
    
    CGRect ordersourceLabelRect = CGRectMake(leftSpace, currentHeight, 200, labelHeight);
    UILabel *ordersourceLabel = [[UILabel alloc] initWithFrame:ordersourceLabelRect];
    ordersourceLabel.text = [@"渠道来源:" stringByAppendingString:serverInfo.orderSourceText];
    ordersourceLabel.textAlignment = NSTextAlignmentLeft;
    ordersourceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:ordersourceLabel];
    
    currentHeight += labelHeight + 5;
    
    UILabel *splitLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, currentHeight-2, SCREEN_WIDTH-2*leftSpace, 1)];
    splitLabel.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:splitLabel];
    
    NSUInteger orderNum = [serverInfo.orderArray count];
    NSUInteger productNum = [serverInfo getProductNum];
    
    for (int i=0; i<orderNum; i++) {
        
        OrderCupcake *ele = [serverInfo.orderArray objectAtIndex:i];
        NSString *type = ele.type;
        if ([@"1" isEqualToString:type]) {
            currentHeight = [self initCupcakeView:ele top:currentHeight inView:self.contentView];
        }else if([@"2" isEqualToString:type]) {
            currentHeight = [self initCupcakeView:ele top:currentHeight inView:self.contentView];
        }else if([@"3" isEqualToString:type]){
            currentHeight = [self initFlavorProductView:ele top:currentHeight inView:self.contentView];
        }
        
        if (i<orderNum-1) {
            currentHeight += 5;
            UILabel *innerSplitLabel = [[UILabel alloc] initWithFrame:CGRectMake(64/2 + 94/2.0 + 79/2.0, currentHeight - 2, SCREEN_WIDTH-2*leftSpace-10-80, 1)];
            innerSplitLabel.backgroundColor = [UIColor grayColor];
            [self.contentView addSubview:innerSplitLabel];
        }
        
    }
    
    currentHeight += 5;
    UILabel *splitEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, currentHeight, SCREEN_WIDTH-2*leftSpace, 1)];
    splitEndLabel.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:splitEndLabel];
    
    NSString *totalProductStr = @"共##件商品 应收";
    totalProductStr = [totalProductStr stringByReplacingOccurrencesOfString:@"##" withString:[NSString stringWithFormat:@"%ld",(unsigned long)productNum]];
    NSString *priceText = [[NSString stringWithFormat:@"  %lf",[serverInfo getPrice] + [serverInfo.orderDeliveryFee floatValue ]] formatCurrency];
    NSString *finalStr = [totalProductStr stringByAppendingString:priceText];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:finalStr];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12]
                       range:[finalStr rangeOfString:totalProductStr]];
    [attrString addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR
                       range:[finalStr rangeOfString:priceText]];
    
    CGRect totalProductLabelRect = CGRectMake(0, currentHeight, SCREEN_WIDTH - 48/2, labelHeight);
    UILabel *totalProductLabel = [[UILabel alloc] initWithFrame:totalProductLabelRect];
    totalProductLabel.textAlignment = NSTextAlignmentRight;
    totalProductLabel.attributedText = attrString;
    totalProductLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:totalProductLabel];
    currentHeight += labelHeight;
    
    currentHeight +=  5;
    UILabel *split2Label = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, currentHeight-2, SCREEN_WIDTH-2*leftSpace, 1)];
    split2Label.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:split2Label];
    
    
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.contentView.contentSize = CGSizeMake(SCREEN_WIDTH, currentHeight);
    [self.view addSubview:self.contentView];
    
}

- (CGFloat)initCupcakeView:(OrderCupcake *)orderCupcake top:(CGFloat)currentHeight inView:(UIView *)view{
    
    NSString *type = orderCupcake.type;
    CupCake *cupcake = nil;
    if ([@"1" isEqualToString:type]) {
        cupcake = orderCupcake.cupcake;
    }else{
        cupcake = orderCupcake.flavorCupcake.cupcake;
    }
    
    
    CGFloat imgLeft       = 30/2 + 64/2;
    CGFloat cakeTop       = 9/2.0;
    CGFloat cakeImgWidth  = 94/2.0;
    CGFloat cakeImgHeight = 113.0/2;
    
    
    CGRect cupcakeImgViewRect = CGRectMake(imgLeft, currentHeight+cakeTop, cakeImgWidth, cakeImgHeight);
    CupcakePicView *cupcakeImgView = [[CupcakePicView alloc] initWithCupcake:cupcake lookType:PIC_CUT_OVER_LOOK];
    cupcakeImgView.frame = cupcakeImgViewRect;
    [view addSubview:cupcakeImgView];
    
    CGFloat textLeft = 64/2 + cakeImgWidth + 79/2.0;
    
    CGFloat textHeight = (2 *  cakeTop +cakeImgHeight)/4.0;
    CGRect cakeMateralLabelRect = CGRectMake(textLeft, currentHeight, 100, textHeight);
    UILabel *cakeMateralLabel = [[UILabel alloc] initWithFrame:cakeMateralLabelRect];
    cakeMateralLabel.text = cupcake.cake.materialName;
    cakeMateralLabel.textColor = TEXT_COLOR;
    cakeMateralLabel.textAlignment = NSTextAlignmentLeft;
    cakeMateralLabel.font = [UIFont systemFontOfSize:detailTxtFontSize];
    [view addSubview:cakeMateralLabel];
    
    CGRect icingMateralLabelRect = CGRectMake(textLeft, currentHeight+textHeight, 100, textHeight);
    UILabel *icingMateralLabel = [[UILabel alloc] initWithFrame:icingMateralLabelRect];
    icingMateralLabel.text = cupcake.icing.materialName;
    icingMateralLabel.textColor = TEXT_COLOR;
    icingMateralLabel.textAlignment = NSTextAlignmentLeft;
    icingMateralLabel.font = [UIFont systemFontOfSize:detailTxtFontSize];
    [view addSubview:icingMateralLabel];
    
    CGFloat tmpTop = textHeight * 2;
    if (cupcake.topping && ![kDefaultToppingId isEqualToString:cupcake.topping.pid]) {
        CGRect toppingMateralLabelRect = CGRectMake(textLeft, currentHeight + tmpTop, 100, textHeight);
        UILabel *toppingMateralLabel = [[UILabel alloc] initWithFrame:toppingMateralLabelRect];
        toppingMateralLabel.text = cupcake.topping.materialName;
        toppingMateralLabel.textColor = TEXT_COLOR;
        toppingMateralLabel.textAlignment = NSTextAlignmentLeft;
        toppingMateralLabel.font = [UIFont systemFontOfSize:detailTxtFontSize];
        [view addSubview:toppingMateralLabel];
        tmpTop += textHeight;
    }
    
    if (cupcake.stuffing && ![kDefaultStuffingId isEqualToString:cupcake.stuffing.pid]) {
        CGRect stuffingMateralLabelRect = CGRectMake(textLeft, currentHeight + tmpTop, 100, textHeight);
        UILabel *stuffingMateralLabel = [[UILabel alloc] initWithFrame:stuffingMateralLabelRect];
        stuffingMateralLabel.text = cupcake.stuffing.materialName;
        stuffingMateralLabel.textColor = TEXT_COLOR;
        stuffingMateralLabel.textAlignment = NSTextAlignmentLeft;
        stuffingMateralLabel.font = [UIFont systemFontOfSize:detailTxtFontSize];
        [view addSubview:stuffingMateralLabel];
        tmpTop += textHeight;
    }
    
    //价钱
    CGFloat priceLabelLeft = SCREEN_WIDTH-48/2.0-100;
    CGRect priceLabelRect = CGRectMake(priceLabelLeft, currentHeight+20, 100, 20);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceLabelRect];
    priceLabel.text = [[NSString stringWithFormat:@"%lf",[cupcake getPrice]] formatCurrency];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = MAIN_COLOR;
    [view addSubview:priceLabel];
    
    //数量
    CGRect productNumLabelRect = CGRectMake(priceLabelLeft, currentHeight+20+36/2.0, 100, 20);
    UILabel *productNumLabel = [[UILabel alloc] initWithFrame:productNumLabelRect];
    NSMutableString *productNumStr = [[NSMutableString alloc] init];
    [productNumStr appendString:[NSString stringWithFormat:@"x%lu",(unsigned long)[orderCupcake num]]];
    productNumLabel.text = productNumStr;
    productNumLabel.textAlignment = NSTextAlignmentRight;
    productNumLabel.font = [UIFont systemFontOfSize:9];
    productNumLabel.textColor = [UIColor colorWithRed:0xDB/255.0 green:0xDC/255.0 blue:0xDC/255.0 alpha:1];
    [self.contentView addSubview:productNumLabel];
    
    currentHeight += 2 * cakeTop + cakeImgHeight;
    return currentHeight;
}

- (CGFloat)initFlavorProductView:(OrderCupcake *)orderCupcake top:(CGFloat)currentHeight inView:(UIView *)view {
    
    FlavorProduct *product = orderCupcake.flavorProduct;
    CGFloat pImgWidth = 154 / 1.5;
    CGFloat pImgHeight = 102 / 1.5;
    CGFloat productTop = (80-pImgHeight)/2.0;
    
    CGRect productViewRect = CGRectMake(leftSpace , currentHeight + productTop, pImgWidth, pImgHeight);
    
    UIImageView *productView = [[UIImageView alloc] initWithFrame:productViewRect];
    [productView sd_setImageWithURL:[[ResouceManager sharedInstance] getServerDownloadPath:product.overServerPic] placeholderImage:[UIImage imageNamed:@"flaover-placeholder@2x"]];
    [view addSubview:productView];
    
    
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+pImgWidth+10, currentHeight, 100, 72)];
    productNameLabel.text = product.productName;//shareText;
    productNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    productNameLabel.numberOfLines = 0;
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.font = [UIFont systemFontOfSize:detailTxtFontSize];
    
    [view addSubview:productNameLabel];
    
    //价钱
    CGRect priceLabelRect = CGRectMake(SCREEN_WIDTH-leftSpace-100, currentHeight+20, 100, 20);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceLabelRect];
    priceLabel.text = [product.productPrice formatCurrency];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = MAIN_COLOR;
    [view addSubview:priceLabel];
    
    //数量
    CGRect productNumLabelRect = CGRectMake(SCREEN_WIDTH-leftSpace-100, currentHeight+40, 100, 20);
    UILabel *productNumLabel = [[UILabel alloc] initWithFrame:productNumLabelRect];
    NSMutableString *productNumStr = [[NSMutableString alloc] init];
    [productNumStr appendString:[NSString stringWithFormat:@"x%lu",(unsigned long)orderCupcake.num]];
    productNumLabel.text = productNumStr;
    productNumLabel.textAlignment = NSTextAlignmentRight;
    productNumLabel.font = [UIFont systemFontOfSize:9];
    productNumLabel.textColor = [UIColor colorWithRed:0xDB/255.0 green:0xDC/255.0 blue:0xDC/255.0 alpha:1];
    [view addSubview:productNumLabel];
    
    currentHeight += 80;
    
    return currentHeight;
}

@end
