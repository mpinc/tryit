//
//  UserRestCell.h
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"

@interface UserRestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *restImageView;
@property (weak, nonatomic) IBOutlet UILabel *restNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (void) setRestaurantItem:(RestaurantItem *) item;

@end
