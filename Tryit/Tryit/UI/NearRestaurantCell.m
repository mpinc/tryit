//
//  NearRestaurantCell.m
//  Tryit
//
//  Created by Mars on 3/13/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "NearRestaurantCell.h"
#import "UIImageView+AFNetworking.h"

@implementation NearRestaurantCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setRestaurantItem:(RestaurantItem *) restaurantItem
{
    if (restaurantItem.restaurantImageUrl != nil) {
        [self.restaurantImage setImageWithURL:restaurantItem.restaurantImageUrl];
    }
    self.nameLabel.text = restaurantItem.name;
    self.addressLabel.text = restaurantItem.address;
}

@end