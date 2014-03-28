//
//  AppDelegate.m
//  Tryit
//
//  Created by Mars on 2/19/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "AppDelegate.h"

#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#import "MenuViewController.h"
#import "DishesViewController.h"

#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "ServerViewController.h"

#import "NSString+Utlity.h"
#import "WebAPI.h"
@interface AppDelegate ()
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    // for menu

    [self readUserInfo];

    [self readServerAddress];
    [self SetServerViewController];

    [WebAPI getManager];
    self.checkInItem = nil;

    self.menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:Nil];

    UINavigationController *menuNavViewController = [[UINavigationController alloc] initWithRootViewController:self.menuViewController];

    menuNavViewController.navigationBar.tintColor = UIColorFromRGB(0x757575);
    menuNavViewController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:UITextAttributeTextColor];
    [menuNavViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg_black"] forBarMetrics:UIBarMetricsDefault];
        
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:[self.menuViewController getViewControllerWithIndex:0] leftDrawerViewController:menuNavViewController];


    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [MMDrawerVisualState slideAndScaleVisualStateBlock];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];


    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setHidden:NO];
    [self.window setRootViewController:self.drawerController];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
  get current AppDelete
 @returns current AppDelete
 */
+ (id) getAppdelegate
{
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
	return app;
}

- (void) setCenterViewControllerWithIndex:(NSInteger) index;
{
    if (self.token != nil) {
        [self.drawerController setCenterViewController:[self.menuViewController getViewControllerWithIndex:index]];
        [self.drawerController closeDrawerAnimated:YES completion:nil];
    }else {
        [self showSignInViewController];
    }
}

- (void) showSignInViewController
{
    if (self.signInNavViewController == nil) {

        WEAKSELF_SC
        FlipToSignIn flipInBlock = ^(){
            weakSelf_SC.signUpNavViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [weakSelf_SC.signInNavViewController presentViewController:self.signUpNavViewController animated:YES completion:^{

            }];
        };

        FlipToSignUp flipUpBlock = ^(){
            weakSelf_SC.signUpNavViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [weakSelf_SC.signInNavViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        };

        SignInViewController *signInViewController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        signInViewController.flipBlock = flipInBlock;
        self.signInNavViewController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
        [self.signInNavViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg_green"] forBarMetrics:UIBarMetricsDefault];

        SignUpViewController *signUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
        signUpViewController.flipBlock = flipUpBlock;
        self.signUpNavViewController = [[UINavigationController alloc] initWithRootViewController:signUpViewController];
        [self.signUpNavViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg_green"] forBarMetrics:UIBarMetricsDefault];
    }

    [self.drawerController presentViewController:self.signInNavViewController animated:NO completion:^{

    }];
}

- (void) hiddeSignInViewController
{
    self.drawerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.drawerController dismissViewControllerAnimated:YES completion:^{

    } ];
}

- (id) getCouponViewController
{
    return self.menuViewController.cpViewController;
}

- (void) saveUserInfoWithDict:(NSDictionary *)dict
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (dict[accessToken]) {
        [userDefaults setObject:dict[accessToken] forKey:accessToken];
    }
    if (dict[customerId]) {
        [userDefaults setObject:dict[customerId] forKey:customerId];
    }
    [userDefaults synchronize];

    [self readUserInfo];
}

- (void) readUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.token = [userDefaults valueForKey:accessToken];
    self.userId = [userDefaults valueForKey:customerId];
}

- (void) readServerAddress
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mainServerAddress = [userDefaults objectForKey:APPLICATION_SERVICE];
    if (mainServerAddress == nil) {
        self.baseAddress = APPLICATION_SERVICE;
    }else {
        self.baseAddress = mainServerAddress;
    }
}

- (id) getAccessToken
{
    if ([NSString isEmptyString:_token]) {
        [self showSignInViewController];
        return Nil;
    }
    return _token;
}

- (void) SetServerViewController
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showServerViewController)];
    [recognizer setNumberOfTouchesRequired:2];
    [recognizer setNumberOfTapsRequired:2];
    [self.window addGestureRecognizer:recognizer];
}

- (void) showServerViewController
{
    ServerViewController *serverViewController = [[ServerViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:serverViewController];
    [self.drawerController presentViewController:navController animated:YES completion:^{

    }];
}

@end
