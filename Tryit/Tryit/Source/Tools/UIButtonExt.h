//
//  UIButtonExt.h
//
//  Created by Mars on 13-8-20.
//  Copyright (c) 2013年 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (UIButtonExt)

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
- (void)rightImageAndLeftTitle:(float)spacing;
- (void)leftImageAndRightTitle:(float)spacing;

@end
