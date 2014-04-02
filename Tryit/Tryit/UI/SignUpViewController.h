//
//  SignUpViewController.h
//  Tryit
//
//  Created by Mars on 3/11/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitViewController.h"

typedef void (^FlipToSignUp)();

@interface SignUpViewController : FitViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (copy, nonatomic) FlipToSignUp flipBlock;

@end
