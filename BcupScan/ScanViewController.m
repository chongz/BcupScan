//
//  ScanViewController.m
//  Preview
//
//  Created by zhangchong on 11/30/15.
//  Copyright © 2015 com.infohold. All rights reserved.
//

#import "ScanViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Constants.h"
#import "ResouceManager.h"
#import "ScanResultViewController.h"
@interface ScanViewController ()

@end

@implementation ScanViewController
@synthesize capture;
@synthesize scanRectView;
@synthesize decodedLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描";
    self.scanRectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    self.scanRectView.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
    self.scanRectView.center=self.view.center;
    [self.view addSubview:self.scanRectView];
    
    
    self.decodedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, 30 * 4)];
    self.decodedLabel.numberOfLines = 0;
    self.decodedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.decodedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:decodedLabel];
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.capture stop];
        [self.capture.layer removeFromSuperlayer];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AppDelegate shareInstance] showNavBar];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) {
        return;
    }
    
//    [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:result.text waitUntilDone:YES];
    
    NSArray *contentArray = [result.text componentsSeparatedByString:@","];
    if (contentArray != nil && [contentArray count] == 2) {
        [self.capture hard_stop];
        [self.capture stop];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self showResult:result.text];
    }
}

- (void)showResult:(NSString *)text {
    ScanResultViewController *scanResult = [[ScanResultViewController alloc] initWithQRcodeText:text];
    [[AppDelegate shareInstance].navController pushViewController:scanResult animated:YES];
}

@end
