//
//  UserRestViewController.m
//  Tryit
//
//  Created by Mars on 3/18/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UserRestViewController.h"
#import "UserRestInfoView.h"
#import "UserCouponCell.h"
#import "ShareItem.h"
#import "WebAPI.h"
#import "UIFunction.h"

NSString *const UserCouponCellIdentifier = @"UserCouponCellIdentifier";

@interface UserRestViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    [self customBackBarItem];

    UserRestInfoView *userRestInfoView = (UserRestInfoView*)[[[NSBundle mainBundle] loadNibNamed:@"UserRestInfoView" owner:self options:nil] lastObject];
    userRestInfoView.restaurantItem = self.restaurantItem;
    self.tableView.tableHeaderView = userRestInfoView;

    self.title = self.restaurantItem.name;

    WEAKSELF_SC
    [WebAPI getUserShareRestaurantID:self.restaurantItem.biz_id WithSuccess:^(NSMutableArray *array) {
        weakSelf_SC.restaurantItem.couponArray = [NSMutableArray arrayWithArray:array];
        [weakSelf_SC.tableView reloadData];
        [UIFunction removeMaskView];
    } failure:^{
        [UIFunction removeMaskView];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurantItem.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCouponCell *cell =  [tableView dequeueReusableCellWithIdentifier:UserCouponCellIdentifier];

    ShareItem *item = [self.restaurantItem.couponArray objectAtIndex:indexPath.row];

    [cell setShareItem:item];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

@end
