//
//  AppDelegate.h
//  Tryit
//
//  Created by Mars on 2/19/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"
#import "MenuViewController.h"

#define BaseAddress @"BaseAddress"

#define BaseURL @"http://54.186.250.135:8080/"

#define authToken @"auth-token"
#define accessToken @"accessToken"
#define customerId @"customerId"
#define activeValue @"active" 

#define TopX 10

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *signInNavViewController;
@property (strong, nonatomic) UINavigationController *signUpNavViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (strong, nonatomic) RestaurantItem *checkInItem;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *userId;

@property (nonatomic, strong) NSDictionary *serverAddress;
@property (nonatomic, strong) NSString *baseAddress;
@property (nonatomic) BOOL popServerViewController;

+ (id) getAppdelegate;

- (void) setCenterViewControllerWithIndex:(NSInteger) index;

- (void) showSignInViewController;
- (void) hiddeSignInViewController;
- (id) getCouponViewController;

- (void) saveUserInfoWithDict:(NSDictionary *)dict;
- (id) getAccessToken;
- (void) removeUserInfo;


@end
