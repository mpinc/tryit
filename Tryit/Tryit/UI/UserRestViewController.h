//
//  UserRestViewController.h
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"
#import "FitViewController.h"

@interface UserRestViewController : FitViewController

@property (strong, nonatomic) RestaurantItem *restaurantItem;

@end
