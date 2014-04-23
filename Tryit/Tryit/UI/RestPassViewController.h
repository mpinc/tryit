//
//  RestPassViewController.h
//  Tryit
//
//  Created by Mars on 4/22/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitViewController.h"

@interface RestPassViewController : FitViewController
@property (weak, nonatomic) IBOutlet UIButton *restPasswordButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end
