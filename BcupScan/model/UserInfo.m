//
//  UserInfo.m
//  BakeCake
//
//  Created by zhangchong on 10/27/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize memberID;
@synthesize memberPhone;
@synthesize isLogin;
@synthesize memberSex;
@synthesize memberNickname;
@synthesize memberBirth;
@synthesize memberPic;
@synthesize updateTime;
@synthesize memberGrade;
@synthesize memberCity;


- (UserInfo *)initWithLoginUser:(LoginUser *)user isLogin:(BOOL)login{
    self = [super init];
    if (self) {
        self.memberID       = user.memberID;
        self.memberPhone    = user.memberPhone;
        self.memberSex      = user.memberSex;
        self.memberNickname = user.memberNickname;
        self.memberBirth    = user.memberBirth;
        self.memberPic      = user.memberPic;
        self.updateTime     = user.updateTime;
        self.memberGrade    = user.memberGrade;
        self.memberCity     = user.memberCity;
        
        self.isLogin = login;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.memberID  forKey:@"userinfo_memberID"];
    [aCoder encodeObject:self.memberPhone forKey:@"userinfo_memberPhone"];
    [aCoder encodeObject:self.memberSex forKey:@"userinfo_memberSex"];
    [aCoder encodeObject:self.memberCity forKey:@"userinfo_memberCity"];
    [aCoder encodeObject:self.memberNickname forKey:@"userinfo_memberNickname"];
    [aCoder encodeObject:self.memberBirth forKey:@"userinfo_memberBirth"];
    [aCoder encodeObject:self.memberPic forKey:@"userinfo_memberPic"];
    [aCoder encodeObject:self.updateTime forKey:@"userinfo_updateTime"];
    [aCoder encodeObject:self.memberGrade forKey:@"userinfo_memberGrade"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isLogin] forKey:@"userinfo_isLogin"];
}

- (UserInfo *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.memberID       = [aDecoder decodeObjectForKey:@"userinfo_memberID"];
        self.memberPhone    = [aDecoder decodeObjectForKey:@"userinfo_memberPhone"];
        self.memberSex      = [aDecoder decodeObjectForKey:@"userinfo_memberSex"];
        self.memberCity     = [aDecoder decodeObjectForKey:@"userinfo_memberCity"];
        self.memberNickname = [aDecoder decodeObjectForKey:@"userinfo_memberNickname"];
        self.memberBirth    = [aDecoder decodeObjectForKey:@"userinfo_memberBirth"];
        self.memberPic      = [aDecoder decodeObjectForKey:@"userinfo_memberPic"];
        self.updateTime     = [aDecoder decodeObjectForKey:@"userinfo_updateTime"];
        self.memberGrade    = [aDecoder decodeObjectForKey:@"userinfo_memberGrade"];
        self.isLogin        = [[aDecoder decodeObjectForKey:@"userinfo_isLogin"] boolValue];
    }
    
    return self;
}
@end
