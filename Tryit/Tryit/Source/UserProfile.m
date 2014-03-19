//
//  UserProfile.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

- (id) initWithEx
{
    self = [super init];
    if(self != Nil)
    {
        /* @property (strong, nonatomic) NSString *userToken;
         @property (strong, nonatomic) NSString *userName;
         @property (strong, nonatomic) NSString *vipRest;
         @property (strong, nonatomic) NSString *coupons;
         @property (strong, nonatomic) NSString *points;
         @property (strong, nonatomic) NSURL *headImageURL;*/

        self.userName = @"Test User";
        self.vipRest = @"12";
        self.coupons = @"39";
        self.points = @"158";
        self.headImageURL = [NSURL URLWithString:@"http://en.gravatar.com/userimage/62959001/71d05f420c1acab6bac3ba9e34c76dbf.jpg?size=200"];
    }
    return self;
}

@end
