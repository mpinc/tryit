//
//  IngredientInfoCell.m
//  TruMenu
//
//  Created by Mars on 5/8/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "IngredientInfoCell.h"

@implementation IngredientInfoCell

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

- (void) awakeFromNib
{
    self.titleLabel.text = @"Ingredients";
}

- (void) setIngredientInfo:(ProductItem *)item
{
    self.descriptLabel.text = item.ingredients;
}

@end
