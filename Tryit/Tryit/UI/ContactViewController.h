//
//  ContactViewController.h
//  Tryit
//
//  Created by Mars on 3/4/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateCouponItem.h"
#import "FitViewController.h"
@interface ContactViewController : FitViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CreateCouponItem *ccItem;

@end
