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
        MenuItem *exploerDishesItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_EXPLOER_DISHES", nil) Image:@"icon_01"];
        exploerDishesItem.viewController = dishesNavViewController;
        dishedViewController.title = NSLocalizedString(@"MENU_EXPLOER_DISHES", nil);

        CouponViewController *couponViewController = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
        UINavigationController *couponNavViewController = [[UINavigationController alloc] initWithRootViewController:couponViewController];
        MenuItem *createCouponItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_CREATE_COUPON", nil) Image:@"icon_02"];
        createCouponItem.viewController = couponNavViewController;
        couponViewController.title = NSLocalizedString(@"MENU_CREATE_COUPON", nil);

        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        UINavigationController *profileNavViewController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        MenuItem *myProfileItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_MY_PROFILE", nil) Image:@"icon_03"];
        myProfileItem.viewController = profileNavViewController;
        profileViewController.title = NSLocalizedString(@"MENU_MY_PROFILE", nil);

        self.itemArray = @[exploerDishesItem, createCouponItem, myProfileItem];

        if (IsIOS7) {
            [dishesNavViewController.navigationBar setBarTintColor:UIColorFromRGB(0x487530)];
            [couponNavViewController.navigationBar setBarTintColor:UIColorFromRGB(0x487530)];
            [profileNavViewController.navigationBar setBarTintColor:UIColorFromRGB(0x487530)];
        }else {
            [dishesNavViewController.navigationBar setBackgroundColor:UIColorFromRGB(0x487530)];
            [couponNavViewController.navigationBar setBackgroundColor:UIColorFromRGB(0x487530)];
            [profileNavViewController.navigationBar setBackgroundColor:UIColorFromRGB(0x487530)];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.menuTable.separatorColor = UIColorFromRGB(0x555555);
    
    self.menuTable.backgroundView = nil;
    self.menuTable.backgroundColor = UIColorFromRGB(0x555555);
    if (IsIOS7) {
        [self.menuTable setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) getViewControllerWithIndex:(int) index
{
    if (self.itemArray.count > index) {
        MenuItem *menuItem = self.itemArray[index];
        return menuItem.viewController;
    }
    return nil;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.contentView setBackgroundColor:UIColorFromRGB(0x403F3F)];

        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
        [cell.textLabel setHighlightedTextColor:UIColorFromRGB(0x92C958)];
    }

    MenuItem *item = self.itemArray[indexPath.row];
    [cell.imageView setImage:item.menuImage];
    [cell.textLabel setText:item.menuName];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    [appDelegate setCenterViewControllerWithIndex:indexPath.row];

    for (NSIndexPath *indexpathForEach in [tableView indexPathsForVisibleRows]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexpathForEach];
        if (indexPath.row != indexpathForEach.row) {
            [cell.textLabel setHighlighted:NO];
        }else{
            [cell.textLabel setHighlighted:YES];
        }
    }
}

@end
