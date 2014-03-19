//
//  UserCouponCell.h
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareItem.h"

@interface UserCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendFriendsLabel;

@property (strong, nonatomic) ShareItem *shareItem;

- (void) setShareItem:(ShareItem *) item;

@end
