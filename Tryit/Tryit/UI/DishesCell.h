//
//  DishesCell.h
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"

@interface DishesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dishImageView;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *discountButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeightConstraint;

- (void) setDishItem:(ProductItem *) dishItem;

@end
