//
//  ChangePassViewController.m
//  Tryit
//
//  Created by Mars on 4/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ChangePassViewController.h"
#import "WebAPI.h"
#import "NSString+Utlity.h"
#import "UIFunction.h"
#import "AppDelegate.h"
@interface ChangePassViewController ()

@end

@implementation ChangePassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"TITLE_CHANGE_PASSWORD", nil);

    self.restPasswordButton.layer.cornerRadius = 5.0;
    [self.restPasswordButton setTitle:NSLocalizedString(@"TITLE_CHANGE_PASSWORD", nil) forState:UIControlStateNormal];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBroad)];
    recognizer.numberOfTouchesRequired = 1;
    recognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recognizer];

    setViewStyle(self.oldPasswordField);
    setViewStyle(self.replacePasswordField);
    setViewStyle(self.retypePasswordField);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hiddenKeyBroad
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - UITextFieldDelegate

- (NSLayoutConstraint *) getTopConstraint
{
    NSLayoutConstraint *editConstraint = nil;

    for(NSLayoutConstraint *constraint in self.view.constraints)
    {
        if(constraint.firstAttribute == NSLayoutAttributeTop&&
           constraint.secondItem == self.view )
        {
            editConstraint = constraint;
            break;
        }
    }
    return editConstraint;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLayoutConstraint *topConstraint = [self getTopConstraint];
    [UIView animateWithDuration:0.25 animations:^
     {
         int fixHeight = -textField.frame.origin.y + 64 + (iPhone5?88:0);
         int offsetY = fixHeight > 0?0:fixHeight;
         topConstraint.constant = 50 + offsetY;
         [self.view layoutIfNeeded];
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLayoutConstraint *topConstraint = [self getTopConstraint];
    [UIView animateWithDuration:0.25 animations:^
     {
         topConstraint.constant = 50;
         [self.view layoutIfNeeded];
     }];
}

- (IBAction)touchRestPasswordButton:(id)sender {

    if ([NSString isEmptyString:self.oldPasswordField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_USERNAME", nil)];
        return;
    }

    [WebAPI changePasswrodWithOldPassword:self.oldPasswordField.text replacePassword:self.replacePasswordField.text success:^(id responseObject) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHANGE_PASSWORD_SUCCESS", nil)];
        AppDelegate *appDelegate = [AppDelegate getAppdelegate];
        [appDelegate setCenterViewControllerWithIndex:1];
    } failure:^{
        
    }];
}

@end
