//
//  RestCheckHeaderView.h
//  Tryit
//
//  Created by Mars on 4/1/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantItem.h"

typedef void(^showFilterView)();
@interface RestCheckHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *restImageView;
@property (weak, nonatomic) IBOutlet UILabel *restNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *filterLeabl;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (copy, nonatomic) showFilterView block;

@property (strong, nonatomic) RestaurantItem *restItem;
- (void) configRestItem:(RestaurantItem*) item;

- (IBAction)touchCheckInButton:(id)sender;
- (IBAction)touchLocationButton:(id)sender;
- (IBAction)touchPhoneButton:(id)sender;
- (IBAction)touchChangeButton:(id)sender;



@end
