//
//  ServerViewController.h
//  eDianche
//
//  Created by Mars on 13-4-16.
//  Copyright (c) 2013年 SKTLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitViewController.h"
@interface ServerViewController : FitViewController <UITextViewDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextView *serverAddressTextView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *serverArray;

@end
