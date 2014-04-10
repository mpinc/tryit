//
//  ProductInfoCell.m
//  Tryit
//
//  Created by Mars on 4/10/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProductInfoCell.h"

@implementation ProductInfoCell

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

- (void) setProductItem:(ProductItem *) item
{
    self.nameLabel.text = item.name;
    self.descriptionLabel.text = item.description;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", item.price];
}

@end
