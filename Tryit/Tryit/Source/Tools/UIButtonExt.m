//
//  UIButtonExt.m
//
//  Created by Mars on 13-8-20.
//  Copyright (c) 2013年 Sktlab. All rights reserved.
//

#import "UIButtonExt.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIButton (UIButtonExt)

- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;

    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);

    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                            - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);

    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

- (void)rightImageAndLeftTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;

    // right the image
    self.imageEdgeInsets = UIEdgeInsetsMake( 0.0, 0.0, 0.0,-titleSize.width *2 - spacing);

    // left the text
    self.titleEdgeInsets = UIEdgeInsetsMake( 0.0, -imageSize.width*2, 0.0, 0.0);
}

- (void)leftImageAndRightTitle:(float)spacing
{
    // left image
    self.imageEdgeInsets = UIEdgeInsetsMake( 0.0, 0.0, 0.0, spacing);

    // right text
    self.titleEdgeInsets = UIEdgeInsetsMake( 0.0, spacing, 0.0, 0.0);
}

@end