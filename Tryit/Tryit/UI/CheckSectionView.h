//
//  CheckSectionView.h
//  Tryit
//
//  Created by Mars on 3/14/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RestaurantItem.h"

@interface CheckSectionView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (strong, nonatomic) RestaurantItem *restaurantItem;

- (void) setRestItem:(RestaurantItem *) item;
- (IBAction)touchCallButton:(id)sender;


@end
