//
//  ContactCell.h
//  Tryit
//
//  Created by Mars on 3/5/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIContact.h"

@interface ContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectSwitch;

- (void) setContact:(TIContact*) contact;

@end
