//
//  ScanResultViewController.h
//  BcupScan
//
//  Created by zhangchong on 12/11/15.
//  Copyright © 2015 com.infohold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanResultViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSString     *memberPhone;
@property (nonatomic, strong) NSString     *orderId;
@property (nonatomic, assign) CGFloat      topSpace;
@property (nonatomic, assign) CGFloat      leftSpace;
@property (nonatomic, assign) CGFloat      labelHeight;
//@property (nonatomic, assign) CGFloat      tableLeft;
@property (nonatomic, strong) NSString     *qrcode;

- (instancetype)initWithQRcodeText:(NSString *)qrcodeText;
@end
