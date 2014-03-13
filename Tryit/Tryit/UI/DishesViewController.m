//
//  DishesViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//
#import "LocationViewController.h"
#import "DishesViewController.h"

#import "DishesCell.h"
#import "DishItem.h"
#import "AppDelegate.h"
#import "WebAPI.h"

NSString *const DishesItemIdentifier = @"DishesItemIdentifier";

@interface DishesViewController ()

@property (nonatomic, strong) NSMutableArray *dishItemArray;
- (IBAction)touchCameraButton:(id)sender;
- (IBAction)touchLocationButton:(id)sender;

@end

@implementation DishesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        NSArray *array = @[[[DishItem alloc] initWithEx], [[DishItem alloc] initWithEx], [[DishItem alloc] initWithEx], [[DishItem alloc] initWithEx]];
        self.dishItemArray = [[NSMutableArray alloc] initWithArray:array];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.dishesTable registerNib:[UINib nibWithNibName:@"DishesCell" bundle:nil] forCellReuseIdentifier:DishesItemIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dishItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DishesCell *cell =  [tableView dequeueReusableCellWithIdentifier:DishesItemIdentifier];    

    [cell setDishItem:self.dishItemArray[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

#pragma mark - Button Action 

- (IBAction)touchCameraButton:(id)sender {

    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    // coupon view controller's index is 1
    [appDelegate setCenterViewControllerWithIndex:1];
}

- (IBAction)touchLocationButton:(id)sender {
    LocationViewController *locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

@end
