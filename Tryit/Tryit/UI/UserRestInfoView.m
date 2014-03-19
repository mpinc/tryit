//
//  UserRestInfoView.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserRestInfoView.h"
#import "UIImageView+AFNetworking.h"

@implementation UserRestInfoView

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

- (void) setRestaurantItem:(RestaurantItem*) item
{
    _restaurantItem = item;

    /*@property (weak, nonatomic) IBOutlet UIImageView *restImageView;
     @property (weak, nonatomic) IBOutlet UILabel *countLabel;*/
    [self.restImageView setImageWithURL:item.restaurantImageUrl];
    self.countLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_COUNT_PROD", nil), item.couponArray.count, item.point];
}

@end
