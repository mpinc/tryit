//
//  SignInViewController.m
//  Tryit
//
//  Created by Mars on 3/11/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "WebAPI.h"
#import "NSString+Utlity.h"
#import "UIFunction.h"
@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)touchSignInButton:(id)sender;

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"TITLE_SIGN_IN", nil);
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
    [rightButton setTitle:NSLocalizedString(@"TITLE_SIGN_UP", nil) forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(touchSignUpButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    self.userNameField.layer.borderColor = UIColorFromRGB(0x9dc393).CGColor;
    self.userNameField.layer.borderWidth = 1.0;
    self.userNameField.layer.cornerRadius = 5.0;

    self.passwordField.layer.borderColor = UIColorFromRGB(0x9dc393).CGColor;
    self.passwordField.layer.borderWidth = 1.0;
    self.passwordField.layer.cornerRadius = 5.0;

    self.signInButton.layer.cornerRadius = 5.0;

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBroad)];
    recognizer.numberOfTouchesRequired = 1;
    recognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchCancelButton:(id) sender
{
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    [appDelegate hiddeSignInViewController];
}

- (void) touchSignUpButton:(id) sender
{
    self.flipBlock();
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hiddenKeyBroad];
    return NO;
}

- (void) hiddenKeyBroad
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)touchSignInButton:(id)sender {

    if ([NSString isEmptyString:self.userNameField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_USERNAME", nil)];
        return;
    }

    if ([NSString isEmptyString:self.passwordField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_PASSWORD", nil)];
        return;
    }

    WEAKSELF_SC
    [WebAPI loginWithUserName:self.userNameField.text Password:self.passwordField.text success:^(id responseObject) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_LOGIN_SUCCESS", nil)];

        weakSelf_SC.passwordField.text = nil;
        weakSelf_SC.userNameField.text = nil;
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
         self.topConstraint.constant = 110 + offsetY;
         [self.view layoutIfNeeded];
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^
     {
         self.topConstraint.constant = 110;
         [self.view layoutIfNeeded];
     }];
}
@end
