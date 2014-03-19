//
//  ProfileInfoView.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProfileInfoView.h"
#import "UserProfile.h"

#import "UIImageView+AFNetworking.h"

@implementation ProfileInfoView

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

- (void) setUserProfile:(UserProfile*) profile
{
    /*
     @property (weak, nonatomic) IBOutlet UIImageView *headImage;
     @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
     @property (weak, nonatomic) IBOutlet UILabel *restutantLabel;
     @property (weak, nonatomic) IBOutlet UILabel *couponLabel;
     @property (weak, nonatomic) IBOutlet UILabel *pointLabel;

     @property (weak, nonatomic) IBOutlet UIImageView *headImage;
     @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
     @property (weak, nonatomic) IBOutlet UILabel *countLabel;
     
     FORMAT_COUNT_REST
     */

    _userProfile = profile;

    [self.headImage setImageWithURL:profile.headImageURL];
    self.userNameLabel.text = profile.userName;
    self.countLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_COUNT_REST", nil), profile.vipRest, profile.coupons, profile.points];
}

@end
