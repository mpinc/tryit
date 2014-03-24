//
//  CouponViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponViewController.h"
#import "CaptureViewController.h"
#import "ContactViewController.h"

@interface CouponViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation CouponViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25 animations:^
     {
         int offsetY = (-textView.frame.origin.y + 20) > 0?0:(-textView.frame.origin.y + 20);
         self.topConstraint.constant = offsetY;
         self.bottomConstraint.constant = 216;
         [self.view layoutIfNeeded];
     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        self.topConstraint.constant = 10;
        self.bottomConstraint.constant = 10;
        [self.view layoutIfNeeded];
        return NO;
    }
    return YES;
}

#pragma mark - Button Action

- (IBAction)touchPhotoButton:(id)sender {

     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    CaptureViewController *captureViewController = [[CaptureViewController alloc] initWithNibName:@"CaptureViewController" bundle:nil];

    WEAKSELF_SC
    captureViewController.getImageBlock = ^(UIImage *takeImage) {
        [weakSelf_SC.pictureImageView setImage:takeImage];
        [weakSelf_SC.cameraButton setAlpha:0.6];
    };

    [self presentViewController:captureViewController animated:YES completion:^{
        
    }];
}

- (IBAction)touchAddFriendsButton:(id)sender {
    ContactViewController *contactViewController = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    [self.navigationController pushViewController:contactViewController animated:YES];
}

- (void) configByCouponItem:(CouponItem*) couponItem
{
    self.item = couponItem;
}

@end
