//
//  DishesViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//
#import "LocationViewController.h"
#import "DishesViewController.h"
#import "UIFunction.h"
#import "RestCheckViewController.h"
#import "FilterViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#import "DishesCell.h"
#import "ProductItem.h"
#import "AppDelegate.h"
#import "WebAPI.h"
#import "SVPullToRefresh.h"

NSString *const DishesItemIdentifier = @"DishesItemIdentifier";

@interface DishesViewController ()

@property (nonatomic, strong) NSMutableArray *dishItemArray;
@property (nonatomic) BOOL hasLocation;
@property (nonatomic, strong) CLLocationManager *manager;

- (IBAction)touchCameraButton:(id)sender;
- (IBAction)touchLocationButton:(id)sender;

@end

@implementation DishesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.dishItemArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.dishesTable registerNib:[UINib nibWithNibName:@"DishesCell" bundle:nil] forCellReuseIdentifier:DishesItemIdentifier];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.dishesTable.bounds];
    [imageView setImage:[UIImage imageNamed:@"common_bg"]];
    [self.dishesTable setBackgroundView:imageView];

    UIButton *tempLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [tempLocationButton setImage:[UIImage imageNamed:@"btn_location"] forState:UIControlStateNormal];
    [tempLocationButton addTarget:self action:@selector(touchLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tempLocationButton];

    if (IsIOS7) {
        [self.dishesTable setSeparatorInset:UIEdgeInsetsZero];
    }

    self.hasLocation = NO;

    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    [self.manager startUpdatingLocation];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItem *item = self.dishItemArray[indexPath.row];
    WEAKSELF_SC
    [WebAPI getRestaurantWithBizId:item.biz_id success:^(RestaurantItem *restItem) {
        [weakSelf_SC loadRestCheckVCWithItem:restItem PerShowItem:item];
    } failure:^{
        
    }];
}

#pragma mark - prepar rest check view controller

- (void) loadRestCheckVCWithItem:(RestaurantItem*) item PerShowItem:(ProductItem*) perShowItem
{
    WEAKSELF_SC
    [WebAPI getProductWithRestId:item.biz_id success:^(NSMutableArray *array) {
        [LocationViewController perparRestCheckVC:item products:array WithViewController:weakSelf_SC PerShowItem:perShowItem];
        [UIFunction removeMaskView];
    } failure:^{
        [LocationViewController perparRestCheckVC:item products:nil WithViewController:weakSelf_SC PerShowItem:perShowItem];
        [UIFunction removeMaskView];
    }];
}

- (void) touchBackbutton
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void) getTopXDishes
{
    WEAKSELF_SC
    [WebAPI getTopXWithCoordinate:self.manager.location.coordinate success:^(NSMutableArray *array) {
        weakSelf_SC.dishItemArray = [NSMutableArray arrayWithArray:array];
        [weakSelf_SC.dishesTable reloadData];
        [weakSelf_SC.dishesTable.pullToRefreshView stopAnimating];
    } failure:^{
        [weakSelf_SC.dishesTable.pullToRefreshView stopAnimating];
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    if (location != nil) {
        if (location.coordinate.latitude == 0.0f || location.coordinate.longitude == 0.0f) {
            return;
        }
        [manager stopUpdatingLocation];
        
        if (self.hasLocation == NO) {
            [self getTopXDishes];

            [self.dishesTable addPullToRefreshWithActionHandler:^{
                [self getTopXDishes];
            }];
            self.hasLocation = YES;
        }
    }
}

@end
