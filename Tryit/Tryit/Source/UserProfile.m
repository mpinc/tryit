//
//  UserProfile.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

- (id) initWithDict:(NSDictionary*) dict
{
    self = [super init];
    if(self != Nil)
    {
        self.userName = dict[@"username"];
        self.email = dict[@"email"];
        self.vipRest = @"12";
        self.coupons = @"39";
        self.points = dict[@"total_points_earned"];
        self.headImageURL = nil;
    }
    return self;
}

@end
