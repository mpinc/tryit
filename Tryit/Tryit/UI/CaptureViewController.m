//
//  CaptureViewController.m
//  Tryit
//
//  Created by Mars on 3/3/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CaptureViewController.h"
#import "SCDefines.h"
#import "SCCommon.h"
#import "SCCaptureSessionManager.h"

//对焦
#define ADJUSTINT_FOCUS @"adjustingFocus"
#define LOW_ALPHA   0.7f
#define HIGH_ALPHA  1.0f

#define SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE      1   //对焦框是否一直闪到对焦完成

@interface CaptureViewController ()

@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;
@property (nonatomic, strong) SCCaptureSessionManager *captureManager;

@property (nonatomic, strong) NSMutableSet *cameraBtnSet;

@property (nonatomic, assign) CGRect previewRect;

@property (weak, nonatomic) IBOutlet UIButton *cancelButtton;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;

@property (nonatomic, strong) UIView *doneCameraUpView;
@property (nonatomic, strong) UIView *doneCameraDownView;

//对焦
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, assign) int alphaTimes;
@property (nonatomic, assign) CGPoint currTouchPoint;


@end

@implementation CaptureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cameraBtnSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];

#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device removeObserver:self forKeyPath:ADJUSTINT_FOCUS context:nil];
    }
#endif

    self.captureManager = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.cameraBtnSet addObject:self.takeButton];
    [self.cameraBtnSet addObject:self.cancelButtton];

    self.hidesBottomBarWhenPushed = YES;
    _isStatusBarHiddenBeforeShowCamera = [UIApplication sharedApplication].statusBarHidden;
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    //session manager
    SCCaptureSessionManager *manager = [[SCCaptureSessionManager alloc] init];

    //AvcaptureManager
    if (CGRectEqualToRect(_previewRect, CGRectZero)) {
        self.previewRect = CGRectMake(0, 0, SC_APP_SIZE.width, SC_APP_SIZE.height);
    }
    [manager configureWithParentLayer:self.view previewRect:_previewRect];
    self.captureManager = manager;
    [_captureManager.session startRunning];

    [self addCameraCover];
    [self addFocusView];

    //notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:kNotificationOrientationChange object:nil];
}

//拍完照后的遮罩
- (void)addCameraCover {
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SC_APP_SIZE.width, 0)];
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    self.doneCameraUpView = upView;

    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, SC_APP_SIZE.width, SC_APP_SIZE.width, 0)];
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    self.doneCameraDownView = downView;
}

//对焦的框
- (void)addFocusView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x.png"]];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;

#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}

#pragma mark -------------touch to focus---------------
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        //        SCDLog(@"Is adjusting focus? %@", isAdjustingFocus ? @"YES" : @"NO" );
        //        SCDLog(@"Change dictionary: %@", change);
        if (!isAdjustingFocus) {
            self.alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {

    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{

        int alphaNum = (self.alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        self.alphaTimes++;

    } completion:^(BOOL finished) {

        if (self.alphaTimes != -1) {
            [self showFocusInPoint:self.currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    //    [super touchesBegan:touches withEvent:event];

    self.alphaTimes = -1;

    UITouch *touch = [touches anyObject];
    self.currTouchPoint = [touch locationInView:self.view];

    if (CGRectContainsPoint(_captureManager.previewLayer.bounds, self.currTouchPoint) == NO) {
        return;
    }

    [_captureManager focusInPoint:self.currTouchPoint];

    //对焦框
    [_focusImageView setCenter:self.currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);

#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:self.currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)touchTakeButton:(id)sender {
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"设备不支持拍照功能T_T"];
        return;
    }
#endif

    UIButton *button = (UIButton*) sender;

    button.userInteractionEnabled = NO;

    [self showCameraCover:YES];

    __block UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actiView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [actiView startAnimating];
    [self.view addSubview:actiView];

    WEAKSELF_SC
    [_captureManager takePicture:^(UIImage *stillImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [SCCommon saveImageToPhotoAlbum:stillImage];//存至本机
        });

        [actiView stopAnimating];
        [actiView removeFromSuperview];
        actiView = nil;

        if (weakSelf_SC.getImageBlock != nil) {
            weakSelf_SC.getImageBlock(stillImage);
        }

        double delayInSeconds = 2.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            button.userInteractionEnabled = YES;
            [weakSelf_SC showCameraCover:NO];
        });
        [weakSelf_SC touchCancelButton:nil];
    }];

}

- (void)showCameraCover:(BOOL)toShow {

//    [UIView animateWithDuration:0.38f animations:^{
//        CGRect upFrame = _doneCameraUpView.frame;
//        upFrame.size.height = (toShow ? SC_APP_SIZE.width / 2 + CAMERA_TOPVIEW_HEIGHT : 0);
//        _doneCameraUpView.frame = upFrame;
//
//        CGRect downFrame = _doneCameraDownView.frame;
//        downFrame.origin.y = (toShow ? SC_APP_SIZE.width / 2 + CAMERA_TOPVIEW_HEIGHT : _bottomContainerView.frame.origin.y);
//        downFrame.size.height = (toShow ? SC_APP_SIZE.width / 2 : 0);
//        _doneCameraDownView.frame = downFrame;
//    }];
}


- (IBAction)touchCancelButton:(id)sender {

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    [self dismissViewControllerAnimated:YES completion:^{

    }];
}


#define CAN_ROTATE  1

#pragma mark ------------notification-------------
- (void)orientationDidChange:(NSNotification*)noti {

    if (!_cameraBtnSet || _cameraBtnSet.count <= 0) {
        return;
    }
    [_cameraBtnSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIButton *btn = ([obj isKindOfClass:[UIButton class]] ? (UIButton*)obj : nil);
        if (!btn) {
            *stop = YES;
            return ;
        }

        btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait://1
            {
                transform = CGAffineTransformMakeRotation(0);
                break;
            }
            case UIDeviceOrientationPortraitUpsideDown://2
            {
                transform = CGAffineTransformMakeRotation(M_PI);
                break;
            }
            case UIDeviceOrientationLandscapeLeft://3
            {
                transform = CGAffineTransformMakeRotation(M_PI_2);
                break;
            }
            case UIDeviceOrientationLandscapeRight://4
            {
                transform = CGAffineTransformMakeRotation(-M_PI_2);
                break;
            }
            default:
                break;
        }
        [UIView animateWithDuration:0.3f animations:^{
            btn.transform = transform;
        }];
    }];
}

#pragma mark -------------rotate---------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
#if CAN_ROTATE
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
#else
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
#endif
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
#if CAN_ROTATE
    return YES;
#else
    return NO;
#endif
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    return [UIApplication sharedApplication].statusBarOrientation;
	return UIInterfaceOrientationPortrait
    ;
}
#endif


@end
