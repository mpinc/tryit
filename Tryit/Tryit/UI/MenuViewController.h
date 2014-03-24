//
//  MenuViewController.h
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitViewController.h"
#import "CouponViewController.h"
@interface MenuViewController : FitViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CouponViewController *cpViewController;

@property (weak, nonatomic) IBOutlet UITableView *menuTable;

- (id) getViewControllerWithIndex:(int) index;

@end
