//
//  CheckSectionView.m
//  Tryit
//
//  Created by Mars on 3/14/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CheckSectionView.h"
#import "NSString+Utlity.h"
#import "UIFunction.h"
#import "UIButtonExt.h"
#import "WebAPI.h"
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
    [self.callButton.layer setCornerRadius:6];
    [self.callButton.layer setMasksToBounds:YES];
    [self.callButton leftImageAndRightTitle:6];

    [self.checkInButton.layer setCornerRadius:6];
    [self.checkInButton.layer setMasksToBounds:YES];

}

- (IBAction)touchCallButton:(id)sender
{
    if (![NSString isEmptyString:self.restaurantItem.phone_no WithPromptString:NSLocalizedString(@"PROMPT_PHONE_NO_NOT_BE_NIL", Nil)]) {
        [self.restaurantItem.phone_no callPhoneNumber];
    }
}

- (IBAction)touchCheckInButton:(id)sender
{
    [WebAPI customerCheckIn:@"100001" restId:self.restaurantItem.biz_id success:^{
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_IN_SUCCESS", nil)];
    } failure:^{
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_IN_FAIL", nil)];
    }];
}

@end
