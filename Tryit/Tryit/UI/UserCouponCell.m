//
//  UserCouponCell.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserCouponCell.h"
#import "UIImageView+DownLoad.h"
@implementation UserCouponCell

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

- (void) setShareItem:(ShareItem *) item
{

    [self.couponImageView fixSetImageWithURL:item.couponPhotoURL placeholderImage:[UIImage imageNamed:@"default_any"]];
    self.productNameLabel.text = item.productName;
    self.couponNameLabel.text = item.couponName;
    self.shareDateLabel.text = [NSDateFormatter localizedStringFromDate:item.createDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    self.sendFriendsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_SEND_FRIENDS", Nil), item.shareList.count];
}

@end
