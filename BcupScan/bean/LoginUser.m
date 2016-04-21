//
//  LoginUser.m
//  BakeCake
//
//  Created by zhangchong on 10/14/15.
//  Copyright © 2015 com.infohold.BakeCake. All rights reserved.
//

#import "LoginUser.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation LoginUser

@synthesize memberID;
@synthesize memberPhone;
@synthesize memberSex;
@synthesize memberNickname;
@synthesize memberBirth;
@synthesize memberPic;
@synthesize updateTime;
@synthesize memberGrade;
@synthesize memberCity;

- (LoginUser *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {        
        if (dic != nil) {
            self.memberPhone    = [dic objectAvoidNullKey:@"memberPhone"];
            self.memberSex      = [dic objectAvoidNullKey:@"memberSex"];
            self.memberID       = [dic objectAvoidNullKey:@"memberID"];
            self.memberCity     = [dic objectAvoidNullKey:@"memberCity"];
            self.memberNickname = [dic objectAvoidNullKey:@"memberNickname"];
            self.memberBirth    = [dic objectAvoidNullKey:@"memberBirth"];
            self.memberPic      = [dic objectAvoidNullKey:@"memberPic"];
            self.updateTime     = [dic objectAvoidNullKey:@"updateTime"];
            self.memberGrade    = [dic objectAvoidNullKey:@"memberGrade"];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.memberID  forKey:@"memberID"];
    [aCoder encodeObject:self.memberPhone forKey:@"memberPhone"];
    [aCoder encodeObject:self.memberSex forKey:@"memberSex"];
    [aCoder encodeObject:self.memberCity forKey:@"memberCity"];
    [aCoder encodeObject:self.memberNickname forKey:@"memberNickname"];
    [aCoder encodeObject:self.memberBirth forKey:@"memberBirth"];
    [aCoder encodeObject:self.memberPic forKey:@"memberPic"];
    [aCoder encodeObject:self.updateTime forKey:@"updateTime"];
    [aCoder encodeObject:self.memberGrade forKey:@"memberGrade"];
}

- (LoginUser *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.memberID       = [aDecoder decodeObjectForKey:@"memberID"];
        self.memberPhone    = [aDecoder decodeObjectForKey:@"memberPhone"];
        self.memberSex      = [aDecoder decodeObjectForKey:@"memberSex"];
        self.memberCity     = [aDecoder decodeObjectForKey:@"memberCity"];
        self.memberNickname = [aDecoder decodeObjectForKey:@"memberNickname"];
        self.memberBirth    = [aDecoder decodeObjectForKey:@"memberBirth"];
        self.memberPic      = [aDecoder decodeObjectForKey:@"memberPic"];
        self.updateTime     = [aDecoder decodeObjectForKey:@"updateTime"];
        self.memberGrade    = [aDecoder decodeObjectForKey:@"memberGrade"];
    }
    
    return self;
}

@end
