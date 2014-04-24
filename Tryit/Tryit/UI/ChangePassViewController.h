//
//  ChangePassViewController.h
//  Tryit
//
//  Created by Mars on 4/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"

@interface ChangePassViewController : CenterViewController
@property (weak, nonatomic) IBOutlet UIButton *restPasswordButton;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *replacePasswordField;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordField;

@end