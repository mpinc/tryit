//
//  AppDelegate.h
//  Tryit
//
//  Created by Mars on 2/19/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"

#define BaseURL @"http://192.168.1.103:8080"
#define accessToken @"accessToken"
#define customerId @"customerId"

#define APPLICATION_SERVICE @"APPLICATION_SERVICE"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *signInNavViewController;
@property (strong, nonatomic) UINavigationController *signUpNavViewController;
@property (strong, nonatomic) RestaurantItem *checkInItem;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *userId;

@property (nonatomic, strong) NSDictionary *serverAddress;
@property (nonatomic, strong) NSString *baseAddress;

+ (id) getAppdelegate;

- (void) setCenterViewControllerWithIndex:(NSInteger) index;

- (void) showSignInViewController;
- (void) hiddeSignInViewController;
- (id) getCouponViewController;

- (void) saveUserInfoWithDict:(NSDictionary *)dict;
- (id) getAccessToken;


@end
