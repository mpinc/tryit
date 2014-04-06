//
//  ProfileInfoView.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProfileInfoView.h"
#import "UserProfile.h"

#import "UIImageView+DownLoad.h"
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
    _userProfile = profile;

    [self.headImage fixSetImageWithURL:profile.headImageURL placeholderImage:[UIImage imageNamed:@"default-head"]];
    self.userNameLabel.text = profile.email;
    self.countLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_COUNT_REST", nil), profile.vipRest, profile.coupons, profile.points];
    UIImage *image = [[UIImage imageNamed:@"line_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 40, 7, 40)];
    [self.countBgView setImage:image];
}

@end
