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

#define TopX 10

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

    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navbg_green"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];

    UIButton *tempCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    [tempCameraButton setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
    [tempCameraButton addTarget:self action:@selector(touchCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton setCustomView:tempCameraButton];

    UIButton *tempLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [tempLocationButton setImage:[UIImage imageNamed:@"btn_location"] forState:UIControlStateNormal];
    [tempLocationButton addTarget:self action:@selector(touchLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationButton setCustomView:tempLocationButton];

    if (IsIOS7) {
        [self.dishesTable setSeparatorInset:UIEdgeInsetsZero];
    }

    [self getTopXDishes];

    [self.dishesTable addPullToRefreshWithActionHandler:^{
        [self getTopXDishes];
    }];
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
    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
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
        [weakSelf_SC perparRestCheckVC:item WithArray:array PerShowItem:perShowItem];
        [UIFunction removeMaskView];
    } failure:^{
        [weakSelf_SC perparRestCheckVC:item WithArray:nil PerShowItem:perShowItem];
        [UIFunction removeMaskView];
    }];
}

- (void) perparRestCheckVC:(RestaurantItem*) item WithArray:(NSArray*) array PerShowItem:(ProductItem*) perShowItem
{
    RestCheckViewController *restCheckViewController = [[RestCheckViewController alloc] initWithNibName:@"RestCheckViewController" bundle:nil];
    restCheckViewController.perShowProductItem = perShowItem;
    
    FilterViewController *filterViewController = [[FilterViewController alloc] initWithNibName:@"RestCheckViewController" bundle:nil];
    restCheckViewController.restItem = item;
    filterViewController.delegate = restCheckViewController;

    if (array != nil) {
        NSMutableArray *productsArray = [[NSMutableArray alloc] initWithCapacity:0]; // save section array
        NSMutableArray *filterArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableDictionary *filterDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (ProductItem *proItem in array) {
            NSString *type = proItem.type;
            NSMutableArray *productArray = [filterDict objectForKey:type];
            if (productArray == Nil) {
                productArray = [[NSMutableArray alloc] initWithCapacity:0];
                [productsArray addObject:productArray];
                [filterArray addObject:proItem.type];
                [filterDict setObject:productArray forKey:type];
            }
            [productArray addObject:proItem];
        }

        restCheckViewController.productArray = productsArray;

        [filterArray insertObject:@"All" atIndex:0];
        filterViewController.filterArray = filterArray;
    }

    MMDrawerController *mmDrawerController = [[MMDrawerController alloc] initWithCenterViewController:restCheckViewController rightDrawerViewController:filterViewController];
    [mmDrawerController setRestorationIdentifier:@"MMDrawer"];
    [mmDrawerController setMaximumRightDrawerWidth:150.0];
    [mmDrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [mmDrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    mmDrawerController.title = item.name;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [button addTarget:self action:@selector(touchBackbutton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"navback"] forState:UIControlStateNormal];

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    mmDrawerController.navigationItem.leftBarButtonItem = leftButtonItem;

    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:NSLocalizedString(@"TITLE_TOP", nil) forState:UIControlStateNormal];
    [button addTarget:restCheckViewController action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rigthBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    mmDrawerController.navigationItem.rightBarButtonItem = rigthBarButton;

    [self.navigationController pushViewController:mmDrawerController animated:YES];

    item.productArray = restCheckViewController.productArray;
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
    [WebAPI getTopX:TopX success:^(NSMutableArray *array) {
        weakSelf_SC.dishItemArray = [NSMutableArray arrayWithArray:array];
        [weakSelf_SC.dishesTable reloadData];
        [weakSelf_SC.dishesTable.pullToRefreshView stopAnimating];
    } failure:^{
        [weakSelf_SC.dishesTable.pullToRefreshView stopAnimating];
    }];
}

@end
