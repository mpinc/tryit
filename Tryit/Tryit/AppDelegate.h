//
//  AppDelegate.h
//  Tryit
//
//  Created by Mars on 2/19/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *signInNavViewController;
@property (strong, nonatomic) UINavigationController *signUpNavViewController;
@property (strong, nonatomic) RestaurantItem *checkInItem;

+ (id) getAppdelegate;

- (void) setCenterViewControllerWithIndex:(int) index;

- (void) showSignInViewController;
- (void) hiddeSignInViewController;
- (id) getCouponViewController;

@end
