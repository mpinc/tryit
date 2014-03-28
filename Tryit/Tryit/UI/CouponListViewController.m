//
//  CouponListViewController.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CouponViewController.h"
#import "CouponItem.h"
#import "CouponCell.h"
#import "CouponSectionView.h"
#import "WebAPI.h"
#import "UIFunction.h"
#import "AppDelegate.h"

NSString *const CouponListHeadSectionIdentifier = @"CouponListHeadSectionIdentifier";
NSString *const CouponCellIdentifier = @"CouponCellIdentifier";

@interface CouponListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *couponArray;

@end

@implementation CouponListViewController

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

    [self.tableView registerNib:[UINib nibWithNibName:@"CouponSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:CouponListHeadSectionIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:CouponCellIdentifier];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    [imageView setImageWithURL:self.productItem.img_url placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.tableView.tableHeaderView = imageView;

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    [bgImageView setImage:[UIImage imageNamed:@"food_bg"]];
    [self.tableView setBackgroundView:bgImageView];

    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
    WEAKSELF_SC
    [WebAPI getpromoWithProduct:self.productItem success:^(NSMutableArray *array) {
        weakSelf_SC.couponArray = [NSMutableArray arrayWithArray:array];
        weakSelf_SC.productItem.couponArray = weakSelf_SC.couponArray;
        [weakSelf_SC.tableView reloadData];
        [UIFunction removeMaskView];
    } failure:^{
        [UIFunction removeMaskView];
    }];

    self.title = self.productItem.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell *cell =  [tableView dequeueReusableCellWithIdentifier:CouponCellIdentifier];

    CouponItem *item = [self.couponArray objectAtIndex:indexPath.row];

    [cell setCouponItem:item];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CouponSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CouponListHeadSectionIdentifier];
    [headerView setProductItem:self.productItem];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    CouponItem *item = [self.couponArray objectAtIndex:indexPath.row];
    self.productItem.selectCoupon = item;
    CouponViewController *couponViewController = (CouponViewController*)[appDelegate getCouponViewController];
    [appDelegate setCenterViewControllerWithIndex:1];
    couponViewController.item  = self.productItem;
}

@end
