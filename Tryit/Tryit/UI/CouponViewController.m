//
//  CouponViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponViewController.h"
#import "ContactViewController.h"

@interface CouponViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *textBgView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

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
    UIImage *couponImage = [[UIImage imageNamed:@"coupon_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)];
    [self.couponButton setBackgroundImage:couponImage forState:UIControlStateNormal];
    [self.addFriendsButton setBackgroundImage:couponImage forState:UIControlStateNormal];

    [self.couponButton setTitle:NSLocalizedString(@"TITEL_CHOOSE_COUPON", nil) forState:UIControlStateNormal];
    [self.addFriendsButton setTitle:NSLocalizedString(@"TITEL_ADD_YOUR_FRIENDS", nil) forState:UIControlStateNormal];

    UIImage *photoImage = [[UIImage imageNamed:@"bg_photo"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.pictureImageView setImage:photoImage];
    UIImage *textImage = [[UIImage imageNamed:@"bg_text"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.textBgView setImage:textImage];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setContentSize:CGSizeMake(320, 1000)];
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
         [self.view layoutIfNeeded];
     }];
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^
         {
             self.topConstraint.constant = 10;
             [self.view layoutIfNeeded];
         }];

        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }else {
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark - Button Action

- (IBAction)touchPhotoButton:(id)sender {

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {

    }

    UIImagePickerController *imagePickerCintroller = [[UIImagePickerController alloc] init];

    imagePickerCintroller.sourceType = UIImagePickerControllerSourceTypeCamera;

    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:

    imagePickerCintroller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePickerCintroller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerCintroller.allowsEditing = NO;
    imagePickerCintroller.delegate = self;

    [self presentViewController:imagePickerCintroller animated:YES completion:^{

    }];
}

- (IBAction)touchAddFriendsButton:(id)sender {

    [self.shareTextView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^
     {
         self.topConstraint.constant = 10;
         [self.view layoutIfNeeded];
     }];


    ContactViewController *contactViewController = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    [self.navigationController pushViewController:contactViewController animated:YES];
}

- (void) configByCouponItem:(CouponItem*) couponItem
{
    self.item = couponItem;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    DLog(@"%@", editingInfo);

    CGSize size = image.size;

    self.imageHeight.constant = size.height*(300.0/size.width);

    [self.pictureImageView setImage:image];

    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
