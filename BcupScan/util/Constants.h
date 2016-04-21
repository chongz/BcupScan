//
//  Constants.h
//  BakeCake
//
//  Created by zhangchong on 8/10/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ResouceManager.h"

#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

#import "BasicCake.h"
#import "Material.h"
#import "OrderCupcake.h"
#import "UserInfo.h"

#import "AFJSONRPCClient.h"
#import "JSONKit.h"

#import "NSString+InputCheck.h"
#import "NSString+stringFormatCurrency.h"
#import "NSDate+currentTime.h"
#import "NSDictionary+NoneKeyCheck.h"
#import "DataUtil.h"


//高德地图apiKey
#define APIKEY @"e066878ff003c0cda0a4212496b71f83"

//默认背景色
#define DEFAULT_BK_COLOR ([UIColor whiteColor])
#define MAIN_COLOR ([UIColor colorWithRed:229/255.0 green:27.0/255 blue:84.0/255 alpha:1])
#define ADDTION_COLOR ([UIColor colorWithRed:181.0/255 green:181.0/255 blue:182.0/255 alpha:1])
#define ADDTION_COLOR2 ([UIColor colorWithRed:219.0/255 green:220.0/255 blue:220.0/255 alpha:1])
#define SELECT_COLOR ([UIColor colorWithRed:64.0/255 green:34.0/255 blue:15.0/255 alpha:1])
#define SELECT_COLOR2 ([UIColor colorWithRed:227.0/255 green:220.0/255 blue:204.0/255 alpha:1])
#define SELECT_COLOR3 ([UIColor colorWithRed:18.0/255 green:154.0/255 blue:146.0/255 alpha:1])

#define MODAL_COLOR ([UIColor colorWithRed:0.490 green:0.490 blue:0.490 alpha:0.5])
#define TITLE_FONT_SIZE 16
//登录、注册、找回密码背景色
#define MODAL_VIEW_CTL_COLOR ([UIColor colorWithRed:0.490 green:0.490 blue:0.490 alpha:1])
#define CORNERRADIUS 18

//屏幕宽、高获取
#define SCREEN_WIDTH (CGRectGetWidth([UIScreen  mainScreen].bounds))
#define SCREEN_WIDTH_HALF (SCREEN_WIDTH/2.0)
#define SCREEN_HEIGHT (CGRectGetHeight([UIScreen  mainScreen].bounds))

#define NAVBAR_HEIGHT 44

#define SYSTEM_BAR_HEIGHT 20
#define TABBAR_HEIGHT 49
#define TOOLBAR_HEIGHT 44
#define COMPONENT_WIDTH 100
#define COMPONENT_HEIGHT 30

//图片资源文件夹
#define IMG_FOLDER @"resource"
#define IMAGE_VIEW_WIDTH 237

#define CUPCAKE_PIC_WIDTH (262 * 0.8)
#define CUPCAKE_PIC_HEIGHT (262 * 0.8)
#define CUPCAKE_TEXT_VIEW_HEIGHT (COMPONENT_HEIGHT * 4)

//分层蛋糕图片大小
#define FACTOR 0.85
#define FACTOR2 0.5
//蛋糕-切面图
#define CAKE_IMAGE_VIEW_WIDTH              317
#define CAKE_IMAGE_VIEW_HEIGHT             182
//奶油
#define ICING_IMAGE_VIEW_WIDTH             239
#define ICING_IMAGE_VIEW_HEIGHT            90
//装饰
#define TOPPING_IMAGE_VIEW_WIDTH           239
#define TOPPING_IMAGE_VIEW_HEIGHT          90
//内陷
#define STUFFING_IMAGE_VIEW_WIDTH          124
#define STUFFING_IMAGE_VIEW_HEIGHT         63

//俯瞰图
#define CAKE_IMAGE_OVER_LOOK_VIEW_WIDTH    317
#define ICING_IMAGE_OVER_LOOK_VIEW_WIDTH   239
#define TOPPING_IMAGE_OVER_LOOK_VIEW_WIDTH 239

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#define ORDER_SPLIT_LINE_FACTOR 5
#define CUPCAKE_HEIGHT (CAKE_IMAGE_VIEW_HEIGHT+ICING_IMAGE_VIEW_HEIGHT+TOPPING_IMAGE_VIEW_HEIGHT)

//#define CAKE_ICON_PATH        @"resource/select/cake"
//#define ICING_ICON_PATH       @"resource/select/icing"
//#define STUFFING_ICON_PATH    @"resource/select/stuffing"
//#define TOPPING_ICON_PATH     @"resource/select/topping"
//#define CAKE_PATH             @"resource/create_cake/cake"
//#define ICING_PATH            @"resource/create_cake/icing"
//#define TOPPING_PATH          @"resource/create_cake/topping"
//#define STUFFING_PATH         @"resource/create_cake/stuffing"
//#define CAKE_OVERLOOK_PATH    @"resource/create_cake_overlook/cake"
//#define ICING_OVERLOOK_PATH   @"resource/create_cake_overlook/icing"
//#define TOPPING_OVERLOOK_PATH @"resource/create_cake_overlook/topping"

//定义选择蛋糕的部分
typedef NS_ENUM(NSUInteger, SELECT_CUPCAKE_COMPONENT) {
    CAKE_SELECTED = 1 << 0,
    ICING_SELECTED = 1 << 1,
    TOPPING_SELECTED = 1 << 2,
    STUFFING_SELECTED = 1 << 3
};

//从哪个视图进入分享页面
typedef NS_ENUM(NSUInteger, FROM_VIEWCONTROLLER) {
    FROM_CREATE_CUPCAKE_CONTROLLER =  0,
    FROM_GALLERY_CONTROLLER = 1,
    FROM_FLAVOR_CONTROLLER = 2
};

//俯瞰、切面图
typedef NS_ENUM(NSUInteger, PIC_LOOK_TYPE) {
    PIC_OVER_LOOK = 0,
    PIC_CUT_OVER_LOOK = 1,
    PIC_CUT_OVER_LOOK2 = 2
};

//控制器
typedef NS_ENUM(NSUInteger, CTL_SELECTED) {
    FLAVOR_CTL_SELECT = 0,
    CREATE_CTL_SELECT = 1,
    GALLERY_CTL_SELECT = 2,
    LOCATIONS_CTL_SELECT = 3,
    MINE_CTL_SELECT = 4
};

//订单状态
typedef NS_ENUM(NSUInteger, ORDER_STATUS) {
    ORDER_ALL = 0,
    ORDER_PAY = 1,
    ORDER_SEND = 2,
    ORDER_RECEIVE = 3,
    ORDER_EVALUATE= 4
};


//喜爱礼盒状态
typedef NS_ENUM(NSUInteger, FLAVOR_PRODUCT_TYPE) {
    PRODUCT_CLASSIC = 0,
    PRODUCT_FLAVOR_CLASSIC = 1,
    PRODUCT_PRODUCT = 2
};

//原料类别
typedef NS_ENUM(NSUInteger, MATERIAL_TYPE) {
    //蛋糕
    MATERIAL_TYPE_CAKE = 1,
    //奶油
    MATERIAL_TYPE_ICING = 2,
    //装饰
    MATERIAL_TYPE_TOPPING = 3,
    //内馅
    MATERIAL_TYPE_STUFFING = 4,
    //淋面
    MATERIAL_TYPE_COATING = 5
};

//原料状态
typedef NS_ENUM(NSUInteger, MATERIAL_STATUS) {
    MATERIAL_STATUS_ONLINE = 1, //上架
    MATERIAL_STATUS_OFFLINE = 2,//下架
    MATERIAL_STATUS_DELETE = 3//删除
};

#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

//弧度
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

//#define DEBUG 1
//log日志输出
#ifdef DEBUG
#  define LOG(...)  NSLog(__VA_ARGS__)
#  define LOG_METHOD_ENTER(...) NSLog(@"%s:%s:%d",__FILE__,__func__, __LINE__)
#  define LOG_OBJ(...) NSLog(@"%s:%d %@",__FILE__,__func__, __LINE__,__VA__ARGS__)
#  define LOG_METHOD_LEAVE(...) NSLog(@"%s:%s:%d",__FILE__,__func__, __LINE__)
#else
#  define LOG(...) ;
#  define LOG_OBJ(...);
#  define LOG_METHOD_ENTER(...);
#  define LOG_METHOD_LEAVE(...);
#endif

#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#ifdef _FOR_DEBUG_
- (BOOL)respondsToSelector:(SEL)rtSelector
{
    NSString *className = NSStringFromClass([self class]) ;
    NSLog(@"%@ --> RTSelector: %s",className,[NSStringFromSelector(rtSelector)UTF8String]);
    return [super respondsToSelector:rtSelector];
}
#endif

#define isRelease YES
#define DBNAME  @"cupcake.db"
//网络相关
#define kServerAddress                         @"www.163.com"
#define kBcupServerAddress                     @"114.215.115.108:8090"
#define ServerAddress                          @"http://"kBcupServerAddress
#define kBcupLoginAddress                      ServerAddress@"/CupcakeAdmin/index"
#define SMART_SERVICE_ENDPOINT                 ServerAddress@"/CupcakeService/jsonrpc/smartengines"
#define kIMG_SERVER_URL                        ServerAddress@"/CupcakeAdmin/"
#define kPORTRIAIT_UPLOAD_URL                  ServerAddress@"/CupcakeService/FileUpload"

//下载图片位置start
#define kIMG_LOCAL_FOLDER                      @"/downloadPic/"
//店铺图片
#define kIMG_LOCAL_STORE_FOLDER                @"/downloadPic/store/"
//喜爱图片
#define kIMG_LOCAL_FLAVOR_FOLDER               @"/downloadPic/flavor/"
#define kIMG_LOCAL_CAKE_ICON_PATH              @"/downloadPic/select/cake/"
#define kIMG_LOCAL_ICING_ICON_PATH             @"/downloadPic/select/icing/"
#define kIMG_LOCAL_STUFFING_ICON_PATH          @"/downloadPic/select/stuffing/"
#define kIMG_LOCAL_TOPPING_ICON_PATH           @"/downloadPic/select/topping/"
#define kIMG_LOCAL_CAKE_PATH                   @"/downloadPic/create_cake/cake/"
#define kIMG_LOCAL_ICING_PATH                  @"/downloadPic/create_cake/icing/"
#define kIMG_LOCAL_TOPPING_PATH                @"/downloadPic/create_cake/topping/"
#define kIMG_LOCAL_STUFFING_PATH               @"/downloadPic/create_cake/stuffing/"
#define kIMG_LOCAL_CAKE_OVERLOOK_PATH          @"/downloadPic/create_cake_overlook/cake/"
#define kIMG_LOCAL_ICING_OVERLOOK_PATH         @"/downloadPic/create_cake_overlook/icing/"
#define kIMG_LOCAL_TOPPING_OVERLOOK_PATH       @"/downloadPic/create_cake_overlook/topping/"
#define kIMG_LOCAL_CAKE_OVERLOOK_FRONT_PATH    @"/downloadPic/create_cake_overlook_front/cake/"
#define kIMG_LOCAL_ICING_OVERLOOK_FRONT_PATH   @"/downloadPic/create_cake_overlook_front/icing/"
#define kIMG_LOCAL_TOPPING_OVERLOOK_FRONT_PATH @"/downloadPic/create_cake_overlook_front/topping/"
//下载图片位置end

#define kUserPickName    @"店内自提"
#define kASAPDilivery    @"尽快送达"
#define kConfirmReceive  @"确认收货"
#define kEvaluateProduct @"评价"

#define kSysConfigFreeDeliveryCharge    @"freeDeliveryCharge"
#define kSysConfigFreight               @"freight"
#define kSysConfigMakeCustomCupcakeTime @"makeCustomCupcakeTime"
#define kSysConfigStoreWorkingTime      @"WorkTime"

//生成蛋糕整体图片存放位置，名称 documentPath + filename
#define KSharePicName           @"share.png"
#define kShareCutoverName       @"shareCutover.png"
#define kShareOverlookName      @"shareOverlook.png"
#define kShareOverlookFrontName @"shareOverLookFront.png"
#define kDefaultToppingId       @"-1"
#define kDefaultStuffingId      @"-1"
#define REQUEST_SUCCESS         @"0000"
#define REQUEST_FAILED          @"0002"
#define ALI_PAY_URL             @"payType=alipay"
#define WECHAT_PAY_URL          @"payType=weixin"
//接口相关
#define PORTRAIT_SUB_NAME @"_portrait.png"
//文件
#define PRIVACY_POLICY_FILE_NAME @"PrivacyPolicy.txt"
#define TERMS_OF_USE_FILE_NAME   @"TermsofUse.txt"
#define USER_REGIST_FILE_NAME    @"UserRegistNotice.txt"

//设备类型
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_S (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6_S_P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IP6_TO_IP6SP_SCALE (736.0/667.0)

@interface Constants : NSObject
@end
