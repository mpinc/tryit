//
//  ProductInfoCell.h
//  Tryit
//
//  Created by Mars on 4/10/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//
// Mutable Line
/* Show a title in left, a green lable in right, and a description in bottom*/

#import <UIKit/UIKit.h>
#import "ProductItem.h"
@interface ProductInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) ProductItem *prodItem;

- (void) setProductItem:(ProductItem *) item;
@end
