//
//  UIFunction.h
//  JieZuForIPhone
//
//  Created by Mars on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface UIFunction : NSObject <UIAlertViewDelegate>
+ (UIFunction*) shareUIFunction;
+ (void) showAlertWithMessage:(NSString *)message;
- (void) showAlertWithTitle:(NSString *) title WithMessage:(NSString *)message;

+ (void) showAlertWithString:(NSString*)string Image:(UIImage*)image timeDuration:(int)duration;
+ (void) removeMaskView;
+ (void) showWaitingAlertWithString:(NSString*)string;
+ (void) showWaitingAlertWithString:(NSString*)string WithTarget:(id)target action:(SEL)action Title:(NSString *)title;

+ (void) showLocalNotification:(NSString*) promptString WithSoundName:(NSString*) notiSoundName;

+ (dispatch_source_t) CreateTimerWithDuration:(NSInteger) duration WithHandleBlock:(void (^)(id obj))handleBlock;

+ (id)loadTableCellFromNib:(NSString*)nib;

@end
