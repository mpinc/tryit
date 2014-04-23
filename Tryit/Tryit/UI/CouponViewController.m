//
//  CouponViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ContactViewController.h"
#import "LocationViewController.h"
#import "RestCheckViewController.h"
#import "AppDelegate.h"
#import "UIFunction.h"
#import "NSString+Utlity.h"
#import "CreateCouponItem.h"
@interface CouponViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *textBgView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) UIImage *selectImage;
- (IBAction)touchCouponButton:(id)sender;

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

    [self.addFriendsButton setTitle:NSLocalizedString(@"TITLE_ADD_YOUR_FRIENDS", nil) forState:UIControlStateNormal];

    UIImage *photoImage = [[UIImage imageNamed:@"bg_photo"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.pictureImageView setImage:photoImage];
    UIImage *textImage = [[UIImage imageNamed:@"bg_text"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.textBgView setImage:textImage];

    [self configByProductItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.selectImage == Nil) {
        [self.scrollView setContentSize:CGSizeMake(320, 504)];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSLayoutConstraint *topConstraint = [self getTopConstraint];
    topConstraint.constant = 10;
    [self.view layoutIfNeeded];
    [self.scrollView setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (NSLayoutConstraint *) getTopConstraint
{
    NSLayoutConstraint *editConstraint = nil;

    for(NSLayoutConstraint *constraint in self.view.constraints)
    {
        if(constraint.firstAttribute == NSLayoutAttributeTop&&
           constraint.firstItem == self.scrollView )
        {
            editConstraint = constraint;
            break;
        }
    }
    return editConstraint;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLayoutConstraint *topConstraint = [self getTopConstraint];
    [UIView animateWithDuration:0.25 animations:^
     {
         int fixHeight = -textView.frame.origin.y + 55 + (iPhone5?88:0);
         int offsetY = fixHeight > 0?0:fixHeight;
         topConstraint.constant = offsetY;
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
        NSLayoutConstraint *topConstraint = [self getTopConstraint];
        [UIView animateWithDuration:0.25 animations:^
         {
             topConstraint.constant = 10;
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

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"MAIN_TITLE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"TITLE_CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TITLE_CHOOSE_PHOTO", nil), NSLocalizedString(@"TITLE_TAKE_PHOTO", nil),nil];
    [actionSheet showInView:self.view];
}

- (IBAction)touchAddFriendsButton:(id)sender {

    [self.shareTextView resignFirstResponder];
    NSLayoutConstraint *topConstraint = [self getTopConstraint];
    [UIView animateWithDuration:0.25 animations:^
     {
         topConstraint.constant = 10;
         [self.view layoutIfNeeded];
     }];

    if (self.selectImage == nil) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_IMAGE_NULL", nil)];
        return;
    }

    if (self.item == nil) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_PRODUCT_NULL", nil)];
        return;
    }

    if ([NSString isEmptyString:self.shareTextView.text]) {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_SHAREWORD_NULL", nil)];
        return;
    }

    CreateCouponItem *ccItem = [[CreateCouponItem alloc] init];
    ccItem.bizId = self.item.biz_id;
    ccItem.promotionId = self.item.selectCoupon.promotion_id;
    ccItem.image = self.pictureImageView.image;
    ccItem.shareWord = self.shareTextView.text;
    ccItem.couponName = self.item.selectCoupon.name;
    ccItem.productName = self.item.name;

    ContactViewController *contactViewController = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    contactViewController.ccItem = ccItem;
    [self.navigationController pushViewController:contactViewController animated:YES];
}

- (void) configByProductItem
{
    if (self.item != nil) {
        NSString *buttonTitle = [NSString stringWithFormat:@"%@ %@", self.item.name, self.item.selectCoupon.name];
        [self.couponButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
}

- (IBAction)touchCouponButton:(id)sender {

    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    if (appDelegate.checkInItem == nil) {
        LocationViewController *locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
        [self.navigationController pushViewController:locationViewController animated:YES];
    }else {
        RestCheckViewController *restCheckViewController = [[RestCheckViewController alloc] initWithNibName:@"RestCheckViewController" bundle:nil];
        restCheckViewController.restItem = appDelegate.checkInItem;
        [self.navigationController pushViewController:restCheckViewController animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    DLog(@"%@", editingInfo);
    UIImage *resizeImage = [UIFunction resizeImageWithImage:image];
    CGSize size = resizeImage.size;
    self.imageHeight.constant = size.height*(300.0/size.width);

    [self.pictureImageView setImage:resizeImage];
    self.selectImage = resizeImage;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];

    [self.shareTextView resignFirstResponder];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // choose Photo
        {
            [self showImagePickWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
        case 1: // take Photo
        {
            [self showImagePickWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        }
        default:
            break;
    }
}

- (void) showImagePickWithSourceType:(UIImagePickerControllerSourceType) SourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:SourceType]) {
        UIImagePickerController *imagePickerCintroller = [[UIImagePickerController alloc] init];
        imagePickerCintroller.sourceType = SourceType;
        imagePickerCintroller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:SourceType];
        imagePickerCintroller.allowsEditing = NO;
        imagePickerCintroller.delegate = self;
        if (SourceType == UIImagePickerControllerSourceTypeCamera) {
            imagePickerCintroller.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        }

        [self presentViewController:imagePickerCintroller animated:YES completion:^{

        }];
    }else {
        if (SourceType != UIImagePickerControllerSourceTypeCamera) {
            [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_ACCESS_PHOTO_FAIL", nil)];
        }else{
            [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_ACCESS_CAMERA_FAIL", nil)];
        }
    }
}

@end
