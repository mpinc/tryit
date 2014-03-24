//
//  CouponCell.h
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponItem.h"

@interface CouponCell : UITableViewCell

@property (strong, nonatomic) CouponItem *couItem;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

- (void) setCouponItem:(CouponItem *) item;

@end
