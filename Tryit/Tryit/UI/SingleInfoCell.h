//
//  SingleInfoCell.h
//  TruMenu
//
//  Created by Mars on 5/8/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"

@interface SingleInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

- (void) setCalariesInfo:(ProductItem *) item;
- (void) setSpicinessScaleInfo:(ProductItem *) item;
@end
