//
//  SingleInfoCell.m
//  TruMenu
//
//  Created by Mars on 5/8/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "SingleInfoCell.h"

@implementation SingleInfoCell

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

- (void) setCalariesInfo:(ProductItem *) item
{
    self.nameLabel.text = @"Calaries";
    self.countLabel.text = [NSString stringWithFormat:@"%d cal", item.calaries];
}

- (void) setSpicinessScaleInfo:(ProductItem *) item
{
    self.nameLabel.text = @"Spiciness Scale";
    self.countLabel.text = [NSString stringWithFormat:@"%d out of 5", item.spicinessScale];
}

@end
