//
//  CouponListViewController.h
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"
#import "FitViewController.h"
@interface CouponListViewController : FitViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ProductItem *productItem;

@end
