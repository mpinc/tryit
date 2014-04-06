//
//  UserRestCell.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserRestCell.h"

#import "UIImageView+DownLoad.h"
@implementation UserRestCell

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

- (void) setRestaurantItem:(RestaurantItem *) item
{
    [self.restImageView fixSetImageWithURL:item.restaurantImageUrl placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.restNameLabel.text = item.name;
    self.pointLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_MY_POINTS", nil), item.point];
    self.addressLabel.text = item.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", item.distance];
}

@end
