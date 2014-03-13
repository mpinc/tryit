//
//  DishesCell.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "DishesCell.h"
#import "UIImageView+AFNetworking.h"

@implementation DishesCell

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

- (void)prepareForReuse
{
    
}

- (void) setDishItem:(DishItem *) dishItem
{
    [self.dishImageView setImageWithURL:dishItem.dishImageUrl];
    self.restaurantLabel.text = @"KFC";
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGSize size = [self.restaurantLabel.text sizeWithFont:self.restaurantLabel.font constrainedToSize:CGSizeMake(200.0f, 200.0f) lineBreakMode:NSLineBreakByWordWrapping];

    NSLayoutConstraint *restaurantWidthConstraint = self.restaurantLabel.constraints[0];
    restaurantWidthConstraint.constant = size.width + 10;

    [super layoutSubviews];
}

@end
