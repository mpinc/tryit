//
//  FilterViewController.h
//  Tryit
//
//  Created by Mars on 4/1/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>

@optional

- (void) selectFilterIndex:(NSInteger) index;

@end

@interface FilterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *filterArray;
@property (weak, nonatomic) id<FilterViewControllerDelegate> delegate;
@end
