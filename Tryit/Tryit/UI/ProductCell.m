//
//  ProductCell.m
//  Tryit
//
//  Created by Mars on 3/14/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProductCell.h"
#import "UIImageView+DownLoad.h"
#import "NSString+Utlity.h"
@implementation ProductCell

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

- (void) setProduct:(ProductItem *) item
{
    [self.productImageView fixSetImageWithURL:item.img_url placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.nameLabel.text = item.name;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", item.price];
    self.descriptionLabel.text = item.description;

    self.discountButton.hidden = [NSString isEmptyString:item.promotion_id];
    if (self.discountButton.hidden == NO) {
        self.discountButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.discountButton.transform = CGAffineTransformMakeRotation(M_PI_4);
        [self.discountButton setTitle:item.promotionName forState:UIControlStateNormal];
    }
}

@end
