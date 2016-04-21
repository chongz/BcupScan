//
//  FlavorProduct.m
//  BakeCake
//
//  Created by zhangchong on 10/19/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "FlavorProduct.h"
#import "ResouceManager.h"
#import "NSDictionary+NoneKeyCheck.h"
#import "ProductItem.h"

@implementation FlavorProduct
@synthesize updateTime;
@synthesize productDes;
@synthesize cutPic;
@synthesize overPic;
@synthesize overServerPic;
@synthesize productPrice;
@synthesize productName;
@synthesize productID;
@synthesize productKind;
@synthesize productType;
@synthesize productState;
@synthesize productStuffing;
@synthesize productTopping;
@synthesize productCake;
@synthesize productIcing;
@synthesize productTime;

@synthesize productDesArray;
@synthesize shareText;
@synthesize ppBackgroundPic;
@synthesize ppBackgroundServerPic;
@synthesize isPlainText;

- (FlavorProduct *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.updateTime            = [dic objectAvoidNullKey:@"updateTime"];
        self.productDes            = [dic objectAvoidNullKey:@"productDes"];
        self.cutPic                = [dic objectAvoidNullKey:@"cutPic"];
        self.overServerPic         = [dic objectAvoidNullKey:@"overPic"];
        self.overPic               = [[ResouceManager sharedInstance] getFileName:self.overServerPic];
        self.productPrice          = [dic objectAvoidNullKey:@"productPrice"];
        self.productTime           = [dic objectAvoidNullKey:@"productTime"];
        self.productName           = [dic objectAvoidNullKey:@"productName"];
        self.productID             = [dic objectAvoidNullKey:@"productID"];
        self.productKind           = [dic objectAvoidNullKey:@"productKind"];
        self.productType           = [dic objectAvoidNullKey:@"productType"];
        self.productState          = [dic objectAvoidNullKey:@"productState"];
        self.productStuffing       = [dic objectAvoidNullKey:@"productStuffing"];
        self.productTopping        = [dic objectAvoidNullKey:@"productTopping"];
        self.productCake           = [dic objectAvoidNullKey:@"productCake"];
        self.productIcing          = [dic objectAvoidNullKey:@"productIcing"];
        
        self.productDesArray       = [[NSMutableArray alloc] init];
        [self initDesArray];


        self.ppBackgroundServerPic = [dic objectAvoidNullKey:@"ppBackgroundServerPic"];
        self.ppBackgroundPic       = [dic objectAvoidNullKey:@"ppBackgroundPic"];

        shareText = [[NSMutableString alloc] init];
        [shareText appendString:self.productName];
        [shareText appendString:@" 包括:"];
        for (int i=0 ; i < [productDesArray count]; i++) {
            
            ProductItem *item = [productDesArray objectAtIndex:i];
            [shareText appendString:item.productName];
            [shareText appendString:@"x"];
            [shareText appendString:item.productNum];
            
            if (i != [productDesArray count] - 1) {
                [shareText appendString:@","];
            }
        }
        
    }
    return self;
}

- (void)initDesArray {
    //a|3,
    NSArray *itemArray = [self.productDes componentsSeparatedByString:@","];
    
    if (itemArray != nil && [itemArray count] > 0) {
        isPlainText = NO;
        NSMutableArray *delEmptyDataArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[itemArray count]; i++) {
            NSString *ele = [itemArray objectAtIndex:i];
            if (ele != nil && [ele length] > 0) {
                ele = [ele stringByReplacingOccurrencesOfString:@" " withString:@""];
                [delEmptyDataArray addObject:ele];
            }
        }
        
        for (int i=0; i<[delEmptyDataArray count]; i++) {
            NSString *detail = [delEmptyDataArray objectAtIndex:i];
            NSArray *detailArray = [detail componentsSeparatedByString:@"|"];
            if (detailArray != nil && [detailArray count] == 2) {
                ProductItem *item = [[ProductItem alloc] init];
                item.productName = [detailArray objectAtIndex:0];
                item.productNum = [detailArray objectAtIndex:1];
                [self.productDesArray addObject:item];
            }
        }
    }else{
        isPlainText = YES;
    }
    
}

@end
