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
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;

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
    self.flipBlock(nil, nil);
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
    WEAKSELF_SC
    [WebAPI signUpWithPassword:self.passwordField.text email:self.emailField.text success:^(id responseObject) {
        
        weakSelf_SC.userName = weakSelf_SC.emailField.text;
        weakSelf_SC.password = weakSelf_SC.passwordField.text;
        weakSelf_SC.emailField.text = nil;
        weakSelf_SC.passwordField.text = nil;
        weakSelf_SC.confrimField.text = nil;

        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MAIN_TITLE", nil) message:NSLocalizedString(@"PROMPT_SIGN_UP_SUCCESS", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"PROMPT_HAVE_ACITVE", nil), nil];
        [alterView show];
    } failure:^{
        
    }];
}

#pragma mark - UITextFieldDelegate

- (NSLayoutConstraint *) getTopConstraint
{
    NSLayoutConstraint *editConstraint = nil;

    for(NSLayoutConstraint *constraint in self.view.constraints)
    {
        if(constraint.firstAttribute == NSLayoutAttributeTop&&
           constraint.firstItem == self.view )
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
         topConstraint.constant = 30 + offsetY;
         [self.view layoutIfNeeded];
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLayoutConstraint *topConstraint = [self getTopConstraint];
    [UIView animateWithDuration:0.25 animations:^
     {
         topConstraint.constant = 30;
         [self.view layoutIfNeeded];
     }];
}

- (void) hiddenKeyBroad
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.flipBlock(self.userName, self.password);
}

@end
