//
//  IngredientInfoCell.h
//  TruMenu
//
//  Created by Mars on 5/8/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"

@interface IngredientInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;

- (void) setIngredientInfo:(ProductItem *)item;

@end
