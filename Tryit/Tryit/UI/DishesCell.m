//
//  DishesCell.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "DishesCell.h"
#import "UIImageView+DownLoad.h"
#import "NSString+Utlity.h"

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

- (void) setDishItem:(ProductItem *) dishItem
{
    if (dishItem.img_url != nil) {
        [self.dishImageView fixSetImageWithURL:dishItem.img_url
                              placeholderImage:[UIImage imageNamed:@"default_any"]];
    }else{
        UIImage *image = [[UIImage imageNamed:@"default_image"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self.dishImageView setImage:image];
    }

    self.dishNameLabel.text = dishItem.name;
    self.restaurantLabel.text = dishItem.bizName;
    self.descriptionLabel.text = dishItem.type;

    self.discountButton.hidden = [NSString isEmptyString:dishItem.promotion_id];
    if (self.discountButton.hidden == NO) {
        self.discountButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.discountButton.transform = CGAffineTransformMakeRotation(M_PI_4);
        [self.discountButton setTitle:dishItem.promotionName forState:UIControlStateNormal];
    }
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
