//
//  CouponSectionView.m
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponSectionView.h"

@implementation CouponSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setProductItem:(ProductItem *) item
{
    self.nameLabel.text = item.name;
    self.descriptionLabel.text = item.description;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", item.price];
}

@end
