//
//  SignInViewController.h
//  Tryit
//
//  Created by Mars on 3/11/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitViewController.h"

typedef void (^FlipToSignIn)();

@interface SignInViewController : FitViewController <UITextFieldDelegate>
@property (copy, nonatomic) FlipToSignIn flipBlock;

-(void) configUserName:(NSString*) userName Password:(NSString *) password;
- (IBAction)touchRestPasswordButton:(id)sender;

@end
