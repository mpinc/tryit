//
//  SignUpViewController.m
//  Tryit
//
//  Created by Mars on 3/11/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "UIFunction.h"
#import "NSString+Utlity.h"
#import "WebAPI.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confrimField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *emailBgV;
@property (weak, nonatomic) IBOutlet UIView *passwordBgV;
@property (weak, nonatomic) IBOutlet UIView *confrimBgV;

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"TITLE_SIGN_UP", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 28)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton setTitle:NSLocalizedString(@"TITLE_CANCEL", nil) forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(touchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 28)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton setTitle:NSLocalizedString(@"TITLE_SIGN_IN", nil) forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(touchSignInButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    setViewStyle(self.emailBgV);
    setViewStyle(self.passwordBgV);
    setViewStyle(self.confrimBgV);

    self.signUpButton.layer.cornerRadius = 5.0;
    self.signUpButton.layer.masksToBounds = YES;

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBroad)];
    recognizer.numberOfTouchesRequired = 1;
    recognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recognizer];
}

void setViewStyle(UIView *configView)
{
    CGColorRef borderColor = UIColorFromRGB(0x0A5B09).CGColor;
    configView.layer.borderColor = borderColor;
    configView.layer.borderWidth = 1.0;
    configView.layer.cornerRadius = 5.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchCancelButton:(id) sender
{
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    [appDelegate hiddeSignInViewController];
}

- (void) touchSignInButton:(id) sender
{
    self.flipBlock();
}

- (IBAction)touchSingUpButton:(id)sender {
    if ([NSString isEmptyString:self.emailField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_EMAIL", nil)];
        return;
    }

    if ([NSString isEmptyString:self.passwordField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_PASSWORD", nil)];
        return;
    }

    if ([NSString isEmptyString:self.confrimField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_RETYPE_PASSWORD", nil)];
        return;
    }

    if (![self.confrimField.text isEqualToString:self.passwordField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_PASSWORD_NOT_SAME", nil)];
        return;
    }

    [WebAPI signUpWithPassword:self.passwordField.text email:self.emailField.text success:^(id responseObject) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_SIGN_UP_SUCCESS", nil)];

        AppDelegate *appDelegate = [AppDelegate getAppdelegate];

        [appDelegate saveUserInfoWithDict:responseObject];
        [appDelegate hiddeSignInViewController];
    } failure:^{
        
    }];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^
     {
         int fixHeight = -textField.frame.origin.y + 64 + (iPhone5?88:0);
         int offsetY = fixHeight > 0?0:fixHeight;
         self.topConstraint.constant = 30 + offsetY;
         [self.view layoutIfNeeded];
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^
     {
         self.topConstraint.constant = 30;
         [self.view layoutIfNeeded];
     }];
}

- (void) hiddenKeyBroad
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
