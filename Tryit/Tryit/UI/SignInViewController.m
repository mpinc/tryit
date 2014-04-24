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
#import "RestPassViewController.h"
@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *restPasswordButton;
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
    
    setViewStyle(self.userNameField);
    setViewStyle(self.passwordField);

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
    [self hiddenKeyBroad];
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

    [self hiddenKeyBroad];

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
    WEAKSELF_SC
    [UIView animateWithDuration:0.25 animations:^
     {
         int fixHeight = -textField.frame.origin.y + 64 + (iPhone5?88:0);
         int offsetY = fixHeight > 0?0:fixHeight;
         if (topConstraint != nil) {
             topConstraint.constant = 40 + offsetY;
         }
         [weakSelf_SC.view layoutIfNeeded];
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLayoutConstraint *topConstraint = [self getTopConstraint];
    WEAKSELF_SC
    [UIView animateWithDuration:0.25 animations:^
     {
         topConstraint.constant = 40;
         [weakSelf_SC.view layoutIfNeeded];
     }];
}

-(void) configUserName:(NSString*) userName Password:(NSString *) password
{
    if (![NSString isEmptyString:userName]) {
        self.userNameField.text = userName;
    }
    if (![NSString isEmptyString:password]) {
        self.passwordField.text = password;
    }
}

- (IBAction)touchRestPasswordButton:(id)sender {

    RestPassViewController *restPassViewController = [[RestPassViewController alloc] initWithNibName:@"RestPassViewController" bundle:nil];
    [self.navigationController pushViewController:restPassViewController animated:YES];
}
@end
