//
//  LocationViewController.h
//  Tryit
//
//  Created by Mars on 3/13/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitViewController.h"
#import "RestaurantItem.h"
#import "ProductItem.h"
@interface LocationViewController : FitViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

+ (void) perparRestCheckVC:(RestaurantItem*) item products:(NSArray*) array WithViewController:(UIViewController*) viewController PerShowItem:(ProductItem*) perShowItem;

@end
