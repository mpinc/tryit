//
//  UserProfile.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserProfile.h"
#import "NSString+Utlity.h"
@implementation UserProfile

- (id) initWithDict:(NSDictionary*) dict
{
    self = [super init];
    if(self != Nil)
    {
        if ([NSString isEmptyString:dict[@"email"]]) {
            return nil;
        }
        self.userName = dict[@"username"];
        self.email = dict[@"email"];
        self.vipRest = dict[@"bizCount"];
        self.coupons = dict[@"couponCount"];
        self.points = dict[@"total_points_earned"];
        self.headImageURL = nil;
    }
    return self;
}

@end
