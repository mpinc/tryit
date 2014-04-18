//
//  RestCheckViewController.h
//  Tryit
//
//  Created by Mars on 3/14/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"
#import "FitViewController.h"
#import "FilterViewController.h"
#import "ProductItem.h"

@interface RestCheckViewController : FitViewController <FilterViewControllerDelegate>

@property (nonatomic, strong) RestaurantItem *restItem;
@property (strong, nonatomic) NSMutableArray *productArray;
@property (strong, nonatomic) ProductItem *perShowProductItem;

- (void) backToTop;

@end
