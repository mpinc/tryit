//
//  CouponViewController.h
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "CouponItem.h"

@interface CouponViewController : CenterViewController <UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *couponButton;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UITextView *shareTextView;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) CouponItem *item;

- (void) configByCouponItem:(CouponItem*) couponItem;

@end
