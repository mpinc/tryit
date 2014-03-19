//
//  UserRestInfoView.h
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"

@interface UserRestInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *restImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic) RestaurantItem *restaurantItem;

- (void) setRestaurantItem:(RestaurantItem*) item;

@end
