//
//  FitViewController.m
//  Tryit
//
//  Created by Mars on 2/25/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "FitViewController.h"

@interface FitViewController ()

@end

@implementation FitViewController

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
	// Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] && IsIOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (void) touchBackbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) customBackBarItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [button addTarget:self action:@selector(touchBackbutton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"navback"] forState:UIControlStateNormal];

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

@end
