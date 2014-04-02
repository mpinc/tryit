//
//  UserProfile.h
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *vipRest;
@property (strong, nonatomic) NSString *coupons;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSURL *headImageURL;
@property (strong, nonatomic) NSString *email;

- (id) initWithDict:(NSDictionary *) dict;

@end
