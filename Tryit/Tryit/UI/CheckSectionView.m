//
//  CheckSectionView.m
//  Tryit
//
//  Created by Mars on 3/14/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CheckSectionView.h"

@implementation CheckSectionView

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

- (void) setRestItem:(RestaurantItem *) item
{
    self.restaurantItem = item;
    self.nameLabel.text = item.name;
    self.addresslabel.text = item.address;

    if (self.backgroundView == nil) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    }

}

- (IBAction)touchCallButton:(id)sender {

}
- (IBAction)touchCheckInButton:(id)sender {

}

@end
