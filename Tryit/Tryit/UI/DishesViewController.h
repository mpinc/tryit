//
//  DishesViewController.h
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface DishesViewController : CenterViewController <UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dishesTable;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationButton;
@property (nonatomic, strong) CLLocationManager *manager;

@end
