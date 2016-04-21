//
//  ScanViewController.h
//  Preview
//
//  Created by zhangchong on 11/30/15.
//  Copyright © 2015 com.infohold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingObjC.h"


@interface ScanViewController : UIViewController <ZXCaptureDelegate>
@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) UIView    *scanRectView;
@property (nonatomic, strong) UILabel   *decodedLabel;
@end
