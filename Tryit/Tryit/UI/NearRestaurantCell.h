//
//  NearRestaurantCell.h
//  Tryit
//
//  Created by Mars on 3/13/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"
@interface NearRestaurantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void) setRestaurantItem:(RestaurantItem *) restaurantItem;

@end
