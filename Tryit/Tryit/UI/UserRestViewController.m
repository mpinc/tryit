//
//  UserRestViewController.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserRestViewController.h"
#import "UserShareViewController.h"
#import "UserRestInfoView.h"
#import "UserCouponCell.h"
#import "ShareItem.h"

NSString *const UserCouponCellIdentifier = @"UserCouponCellIdentifier";

@interface UserRestViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *couponsArray;

@end

@implementation UserRestViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCouponCell" bundle:nil] forCellReuseIdentifier:UserCouponCellIdentifier];


    UserRestInfoView *userRestInfoView = (UserRestInfoView*)[[[NSBundle mainBundle] loadNibNamed:@"UserRestInfoView" owner:self options:nil] lastObject];
    userRestInfoView.restaurantItem = self.restaurantItem;
    self.tableView.tableHeaderView = userRestInfoView;

    self.couponsArray = self.restaurantItem.couponArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCouponCell *cell =  [tableView dequeueReusableCellWithIdentifier:UserCouponCellIdentifier];

    ShareItem *item = [self.couponsArray objectAtIndex:indexPath.row];

    [cell setShareItem:item];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareItem *item = [self.couponsArray objectAtIndex:indexPath.row];
    UserShareViewController *userShareViewController = [[UserShareViewController alloc] initWithNibName:@"UserShareViewController" bundle:nil];
    userShareViewController.shareItem = item;
    [self.navigationController pushViewController:userShareViewController animated:YES];
}

@end
