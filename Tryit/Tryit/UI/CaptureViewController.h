//
//  CaptureViewController.h
//  Tryit
//
//  Created by Mars on 3/3/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetImageBlock)(UIImage *takeImage);

@interface CaptureViewController : UIViewController

@property (copy, nonatomic) GetImageBlock getImageBlock;

@end
