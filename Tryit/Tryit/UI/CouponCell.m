//
//  CouponCell.m
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

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

- (void) setCouponItem:(CouponItem *)item
{
    self.couponLabel.text = item.name;
    self.descriptionLabel.text = item.couPonDescription;


    if (item.endDate != nil) {
        NSString *endDate = [NSDateFormatter localizedStringFromDate:item.endDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_VALID_UNTIL", nil), endDate];
    }else {
        self.dateLabel.text = @"No time limit";
    }
}

@end
