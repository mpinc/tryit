//
//  ProfileViewController.h
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "UserProfile.h"

@interface ProfileViewController : CenterViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UserProfile *userProfile;

@end
