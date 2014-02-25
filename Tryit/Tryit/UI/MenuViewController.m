//
//  MenuViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "MenuViewController.h"

#import "DishesViewController.h"
#import "CouponViewController.h"
#import "ProfileViewController.h"

#import "AppDelegate.h"

#import "MenuItem.h"

NSString *const ItemTableCellIdentifier  = @"ItemTableCellIdentifier";

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *itemArray;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.title = NSLocalizedString(@"MENU_TITLE", nil);

        // Custom initialization
        DishesViewController *dishedViewController = [[DishesViewController alloc] initWithNibName:@"DishesViewController" bundle:nil];
        UINavigationController *dishesNavViewController = [[UINavigationController alloc] initWithRootViewController:dishedViewController];
        MenuItem *exploerDishesItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_EXPLOER_DISHES", nil) Image:@"exploerDishesItem"];
        exploerDishesItem.viewController = dishesNavViewController;
        dishedViewController.title = NSLocalizedString(@"MENU_EXPLOER_DISHES", nil);

        CouponViewController *couponViewController = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
        UINavigationController *couponNavViewController = [[UINavigationController alloc] initWithRootViewController:couponViewController];
        MenuItem *createCouponItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_CREATE_COUPON", nil) Image:@"createCouponItem"];
        createCouponItem.viewController = couponNavViewController;
        couponViewController.title = NSLocalizedString(@"MENU_CREATE_COUPON", nil);

        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        UINavigationController *profileNavViewController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        MenuItem *myProfileItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_MY_PROFILE", nil) Image:@"myProfileItem"];
        myProfileItem.viewController = profileNavViewController;
        profileViewController.title = NSLocalizedString(@"MENU_MY_PROFILE", nil);

        self.itemArray = @[exploerDishesItem, createCouponItem, myProfileItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) getFristViewController
{
    MenuItem *menuItem = self.itemArray[0];
    return menuItem.viewController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:ItemTableCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ItemTableCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    MenuItem *item = self.itemArray[indexPath.row];
    [cell.imageView setImage:item.menuImage];
    [cell.textLabel setText:item.menuName];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = self.itemArray[indexPath.row];
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    [appDelegate setCenterViewController:item.viewController];
}

@end
