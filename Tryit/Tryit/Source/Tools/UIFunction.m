//
//  UIFunction.m
//  JieZuForIPhone
//
//  Created by Mars on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIFunction.h"

#define SCREEN_HIGHT 480 +(iPhone5?88:0)

static BOOL isShowAlertView = NO;

static UIFunction *shareUIFunction = nil;

#define ALERT_VIEW_TAG 1001
#define CONTANT_ALERT_VIEW_TAG 1002

@implementation UIFunction

+ (UIFunction*) shareUIFunction
{
    @synchronized(self)
    {
        if (shareUIFunction == nil)
        {
            shareUIFunction = [[self alloc] init];
        }
    }
    return shareUIFunction;
}

+ (void) showAlertWithMessage:(NSString *)message
{
    UIFunction *meaasgeFunction = [UIFunction shareUIFunction];
    [meaasgeFunction showAlertWithTitle:NSLocalizedString(@"MAIN_TITLE", nil) WithMessage:message];
}

- (void) showAlertWithTitle:(NSString *) title WithMessage:(NSString *)message
{

//    if (!isShowAlertView) {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
//            isShowAlertView = YES;
            [alert show];
        });
//    }
}

/*
 Mars.luo Add custom tip box (image + string)
 */
+ (void)showAlertWithString:(NSString*)string Image:(UIImage*)image timeDuration:(int)duration
{
	// get width and higthe for  the string which should darw
	UIFont *font = [UIFont systemFontOfSize:18];
	CGSize sizeString = [string sizeWithFont:font constrainedToSize:CGSizeMake(200,SCREEN_HIGHT) lineBreakMode:NSLineBreakByWordWrapping];
	float width = sizeString.width;
	float height = sizeString.height;
    
	// create the view should be shown, keep padding for 15px, keep the view in the center of screen
	UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake((320-width-15)/2.0, (SCREEN_HIGHT-height)/2.0-7.5, width+30, height+30)];
	
	UIImageView *imageView = nil;
	UILabel *label = nil;
	// is need to show image
	if (image != nil)
    {
		
		float imageWidth = CGImageGetWidth(image.CGImage)/2;
		float imageHeight = CGImageGetHeight(image.CGImage)/2;
		
		width = (width > imageWidth ? width : imageWidth) + 20;
		// keep 20px padding
		height = height +imageHeight+20;
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (width +30 - imageWidth)/2 , (height - imageHeight)/2 , imageWidth, imageHeight)];
		[imageView setImage:image];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake((width+15 - sizeString.width)/2, 30 + imageWidth, sizeString.width+15, sizeString.height+15)];
        alertView.frame = CGRectMake((320-width-15)/2.0, (SCREEN_HIGHT-height)/2.0-7.5, width+30, height+30);
	} 
	else 
	{
		//label = [[UILabel alloc] initWithFrame:CGRectMake((width +30 - s.width)/2, 30, s.width+15, s.height+15)];
		alertView.frame = CGRectMake((320 - 200)/2.0, (SCREEN_HIGHT-100)/2.0, 200, 100);
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        
	}
	//set same Text attributes
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:font];
	[label setText:string];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	//no limit for number of line 
	label.numberOfLines = 0;
	[label setLineBreakMode:NSLineBreakByWordWrapping];
	
	[alertView setBackgroundColor:[UIColor blackColor]];
	// set the conrnr for view
	alertView.layer.cornerRadius = 7.5;
	alertView.layer.masksToBounds = YES;
	alertView.tag = ALERT_VIEW_TAG;
	alertView.alpha = 0.8;
    
	[alertView addSubview:label];
	if (imageView != nil)
    {
		[alertView addSubview:imageView];
	}
	
	//create the mask view for screen
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HIGHT)];
	newView.backgroundColor = [UIColor clearColor];
	newView.tag = CONTANT_ALERT_VIEW_TAG;
    
	// get current window
	UIWindow *window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
	[newView addSubview:alertView];
	[window addSubview:newView];
	
	// beginAnimations
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelegate:self];
	
	// set the action when animation complete
	[UIView setAnimationDidStopSelector:@selector(removeMaskView)];
	alertView.alpha = 0.0;
	[UIView commitAnimations];
    
}

// remove the msak view 
+(void) removeMaskView
{
	UIWindow *window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
	UIView *newView = nil;
	
	for (UIView *subView in [window subviews])
    {
		if (subView.tag == CONTANT_ALERT_VIEW_TAG)
        {
			newView = subView;
			
			if (newView != nil)
            {
				
				[newView removeFromSuperview];
			}
//			break;
		}
	}
}

/*
 Mars.luo Add custom tip box (activity indicator view + string)
*/
+ (void)showWaitingAlertWithString:(NSString*)string
{
	// get width and higthe for  the string which should darw
	UIFont *font = [UIFont systemFontOfSize:18];
	CGSize sizeString = [string sizeWithFont:font constrainedToSize:CGSizeMake(200,100) 
							   lineBreakMode:NSLineBreakByWordWrapping];
	float width = sizeString.width;
	float height = sizeString.height;
    
	// create the view should be shown, keep padding for 15px, keep the view in the center of screen
	UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake((320-width-40-30)/2.0, (SCREEN_HIGHT-height-80-30)/2.0, width+30+40, height+30+80)];
	
	UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] 
											  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicatorView setFrame:CGRectMake((alertView.frame.size.width - 37)/2, 35, 37, 37)];
	[indicatorView setHidesWhenStopped:YES];
	[indicatorView setHidden:NO];
	[indicatorView startAnimating];
	[alertView addSubview:indicatorView];
	//set label  keep padding for 15px, 60 is the height of UIActivityIndicatorView (UIActivityIndicatorView and blank space)
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((alertView.frame.size.width - 10 - width)/2.0, 20+60, width+20, height+20)];
	[label setFont:font];
	[label setTextAlignment:NSTextAlignmentCenter];
    
	//set same Text attributes
	[label setText:string];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	label.numberOfLines = 0;
	[label setLineBreakMode:NSLineBreakByWordWrapping];
	
	[alertView setBackgroundColor:[UIColor blackColor]];
	// set the conrnr for view
	alertView.layer.cornerRadius = 7.5;
	alertView.layer.masksToBounds = YES;
	alertView.tag = ALERT_VIEW_TAG;
	alertView.alpha = 0.8;
	[alertView addSubview:label];
	
	//create the mask view for screen
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HIGHT)];
	newView.backgroundColor = [UIColor clearColor];
	newView.tag = CONTANT_ALERT_VIEW_TAG;
	
	// get current window
	UIWindow *window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
	[newView addSubview:alertView];
	[window addSubview:newView];
}

/*
 Mars.luo Add custom tip box (activity indicator view + string + button)
 */
+ (void)showWaitingAlertWithString:(NSString*)string WithTarget:(id)target action:(SEL)action Title:(NSString *)title
{
	// get width and higthe for  the string which should darw
	UIFont *font = [UIFont systemFontOfSize:18];
	CGSize sizeString = [string sizeWithFont:font constrainedToSize:CGSizeMake(200,100) 
							   lineBreakMode:NSLineBreakByWordWrapping];
	float width = sizeString.width;
	float height = sizeString.height;
    
	// create the view should be shown, keep padding for 15px, keep the view in the center of screen
	UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake((320-width-40-30)/2.0, (SCREEN_HIGHT-height-80-30)/2.0, width+30+40, height+30+80 + 30 + 20)];
	
	UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] 
											  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicatorView setFrame:CGRectMake((alertView.frame.size.width - 37)/2, 35, 37, 37)];
	[indicatorView setHidesWhenStopped:YES];
	[indicatorView setHidden:NO];
	[indicatorView startAnimating];
	[alertView addSubview:indicatorView];
	//set label  keep padding for 15px, 60 is the height of UIActivityIndicatorView (UIActivityIndicatorView and blank space)
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((alertView.frame.size.width - 10 - width)/2.0, 20+60, width+20, height+20)];
	[label setFont:font];
	[label setTextAlignment:NSTextAlignmentCenter];
    
	//set same Text attributes
	[label setText:string];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	label.numberOfLines = 0;
	[label setLineBreakMode:NSLineBreakByWordWrapping];
	
	[alertView setBackgroundColor:[UIColor blackColor]];
	// set the conrnr for view
	alertView.layer.cornerRadius = 7.5;
	alertView.layer.masksToBounds = YES;
	alertView.tag = ALERT_VIEW_TAG;
	alertView.alpha = 0.8;
	[alertView addSubview:label];
	
    // create the button for action
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [button setFrame:CGRectMake((alertView.frame.size.width - 10 - button.frame.size.width)/2.0, label.frame.origin.y + label.frame.size.height + 10, button.frame.size.width, button.frame.size.height)];
    [alertView addSubview:button];
    
	//ceate mask view
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HIGHT)];
	newView.backgroundColor = [UIColor clearColor];
	newView.tag = CONTANT_ALERT_VIEW_TAG;
	
	//get current window
	UIWindow *window = [[[UIApplication sharedApplication]windows] objectAtIndex:0];
	[newView addSubview:alertView];
	[window addSubview:newView];
}

+ (void) showLocalNotification:(NSString*) promptString WithSoundName:(NSString*) notiSoundName
{
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        
        alarm.fireDate = [NSDate date];
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        if (notiSoundName)
        {
            alarm.soundName = notiSoundName;
        }
        else
        {
            alarm.soundName = @"ping.caf";
        }
        alarm.alertBody = promptString;
        
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:alarm];
    }
}

/*
    Create Dispatch Timer 
 */
dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                      uint64_t leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

+ (dispatch_source_t) CreateTimerWithDuration:(NSInteger) duration WithHandleBlock:(void (^)(id obj))handleBlock
{
    uint64_t interval = duration;
    dispatch_source_t aTimer = CreateDispatchTimer(interval * NSEC_PER_SEC,
                                                   1ull * NSEC_PER_SEC,
                                                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                                   ^{ 
                                                       handleBlock(nil);
                                                   });
    // Store it somewhere for later use.
    if (aTimer)
    {
        return aTimer;
    }
    return nil;
}

+ (id)loadTableCellFromNib:(NSString*)nib
{
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
	for (id currentObject in topLevelObjects) {
		if ([currentObject isKindOfClass:[UITableViewCell class]]) {
			return currentObject;
		}
	}
	return nil;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    isShowAlertView = NO;
}

@end
