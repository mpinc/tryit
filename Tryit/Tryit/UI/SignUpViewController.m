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
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confrimField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *nameBgV;
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

    setViewStyle(self.nameBgV);
    setViewStyle(self.emailBgV);
    setViewStyle(self.passwordBgV);
    setViewStyle(self.confrimBgV);

    self.signUpButton.layer.cornerRadius = 5.0;
    self.signUpButton.layer.masksToBounds = YES;
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
    if ([NSString isEmptyString:self.nameField.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_USERNAME", nil)];
        return;
    }

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

    [WebAPI signUpWithUserName:self.nameField.text Password:self.passwordField.text email:self.emailField.text success:^(id responseObject) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_SIGN_UP_SUCCESS", nil)];

        AppDelegate *appDelegate = [AppDelegate getAppdelegate];

        [appDelegate saveUserInfoWithDict:responseObject];
        [appDelegate hiddeSignInViewController];
    } failure:^{
        
    }];
}
@end
