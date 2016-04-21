//
//  Customer.m
//  BakeCake
//
//  Created by zhangchong on 9/15/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "CustomerAddress.h"
#import "NSDictionary+NoneKeyCheck.h"

@implementation CustomerAddress
@synthesize addressPhone;
@synthesize addressDefault;
@synthesize updateTime;
@synthesize memberPhone;
@synthesize addressCode;
@synthesize addressDetailed;
@synthesize addressCity;
@synthesize addressID;
@synthesize addressName;
@synthesize addressDetailText;
@synthesize addressReceiver;
@synthesize addressCityId;
@synthesize addressDistrict;

- (CustomerAddress *)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.addressID         = [dic objectAvoidNullKey:@"addressID"];
        self.addressPhone      = [dic objectAvoidNullKey:@"addressPhone"];
        self.addressDefault    = [dic objectAvoidNullKey:@"addressDefault"];
        self.updateTime        = [dic objectAvoidNullKey:@"updateTime"];
        self.memberPhone       = [dic objectAvoidNullKey:@"memberPhone"];
        self.addressCode       = [dic objectAvoidNullKey:@"addressCode"];
        self.addressDistrict   = [dic objectAvoidNullKey:@"addressDistrict"];
        self.addressDetailed   = [dic objectAvoidNullKey:@"addressDetailed"];
        self.addressCity       = [dic objectAvoidNullKey:@"addressCity"];
        self.addressCityId     = [dic objectAvoidNullKey:@"addressCityID"];
        self.addressName       = [dic objectAvoidNullKey:@"addressName"];
        self.addressReceiver   = [NSString stringWithFormat:@"%@  %@",self.addressName,self.addressPhone];
        self.addressDetailText = [NSString stringWithFormat:@"%@%@%@",self.addressCity,self.addressDistrict,self.addressDetailed];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.addressID forKey:@"addressID"];
    [aCoder encodeObject:self.addressPhone forKey:@"addressPhone"];
    [aCoder encodeObject:self.addressDefault forKey:@"addressDefault"];
    [aCoder encodeObject:self.updateTime forKey:@"updateTime"];
    [aCoder encodeObject:self.memberPhone forKey:@"memberPhone"];
    [aCoder encodeObject:self.addressCode forKey:@"addressCode"];
    [aCoder encodeObject:self.addressDetailed forKey:@"addressDetailed"];
    [aCoder encodeObject:self.addressCity forKey:@"addressCity"];
    [aCoder encodeObject:self.addressCityId forKey:@"addressCityId"];
    [aCoder encodeObject:self.addressName forKey:@"addressName"];
    [aCoder encodeObject:self.addressReceiver forKey:@"addressReceiver"];
    [aCoder encodeObject:self.addressDetailText forKey:@"addressDetailText"];
    [aCoder encodeObject:self.addressDistrict forKey:@"addressDistrict"];
}

- (CustomerAddress *)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.addressID         = [aDecoder decodeObjectForKey:@"addressID"];
        self.addressPhone      = [aDecoder decodeObjectForKey:@"addressPhone"];
        self.addressDefault    = [aDecoder decodeObjectForKey:@"addressDefault"];
        self.updateTime        = [aDecoder decodeObjectForKey:@"updateTime"];
        self.memberPhone       = [aDecoder decodeObjectForKey:@"memberPhone"];
        self.addressCode       = [aDecoder decodeObjectForKey:@"addressCode"];
        self.addressDetailed   = [aDecoder decodeObjectForKey:@"addressDetailed"];
        self.addressCity       = [aDecoder decodeObjectForKey:@"addressCity"];
        self.addressCityId     = [aDecoder decodeObjectForKey:@"addressCityId"];
        self.addressName       = [aDecoder decodeObjectForKey:@"addressName"];
        self.addressDistrict   = [aDecoder decodeObjectForKey:@"addressDistrict"];
        
        self.addressReceiver   = [aDecoder decodeObjectForKey:@"addressReceiver"];
        self.addressDetailText = [aDecoder decodeObjectForKey:@"addressDetailText"];
    }
    return self;
}
@end
