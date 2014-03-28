//
//  ProductCell.m
//  Tryit
//
//  Created by Mars on 3/14/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProductCell.h"
#import "UIImageView+AFNetworking.h"

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
    [self.productImageView setImageWithURL:item.img_url placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.nameLabel.text = item.name;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", item.price];
    self.descriptionLabel.text = item.description;
}

@end
