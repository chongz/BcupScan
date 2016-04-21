//
//  UserInfo.h
//  BakeCake
//
//  Created by zhangchong on 10/27/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUser.h"

@interface UserInfo : NSObject <NSCoding>
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *memberPhone;
@property (nonatomic, strong) NSString *memberSex;
@property (nonatomic, strong) NSString *memberNickname;
@property (nonatomic, strong) NSString *memberBirth;
@property (nonatomic, strong) NSString *memberPic;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *memberGrade;
@property (nonatomic, strong) NSString *memberCity;
@property (nonatomic, assign) BOOL     isLogin;


- (UserInfo *)initWithLoginUser:(LoginUser *)user isLogin:(BOOL)login;
@end
