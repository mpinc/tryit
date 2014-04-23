//
//  CouponListViewController.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponListViewController.h"
#import "UIImageView+DownLoad.h"
#import "CouponViewController.h"
#import "CouponItem.h"
#import "CouponCell.h"
#import "ProductInfoCell.h"
#import "WebAPI.h"
#import "UIFunction.h"
#import "AppDelegate.h"

NSString *const ProductInfoCellIdentifier = @"ProductInfoCellIdentifier";
NSString *const CouponCellIdentifier = @"CouponCellIdentifier";

@interface CouponListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *itemArray;

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

    self.itemArray = [NSMutableArray arrayWithObjects:ProductInfoCellIdentifier, nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:ProductInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:CouponCellIdentifier];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 213)];
    [imageView fixSetImageWithURL:self.productItem.img_url placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.tableView.tableHeaderView = imageView;

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    [bgImageView setImage:[UIImage imageNamed:@"food_bg"]];
    [self.tableView setBackgroundView:bgImageView];

    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
    WEAKSELF_SC
    [WebAPI getpromoWithProduct:self.productItem success:^(NSMutableArray *array) {
        CouponItem *couponItem = (CouponItem*)[array lastObject];
        weakSelf_SC.productItem.selectCoupon = couponItem;
        [weakSelf_SC.itemArray addObject:CouponCellIdentifier];
        [weakSelf_SC.tableView reloadData];
        [UIFunction removeMaskView];
    } failure:^{
        [UIFunction removeMaskView];
    }];

    self.title = self.productItem.name;
    [self customBackBarItem];
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
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:{
            cell = [self getProductInfoCellWithTable:tableView];
            break;
        }
        case 1:{
            cell = [self getCouponCellWithTable:tableView];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (UITableViewCell*) getProductInfoCellWithTable:(UITableView*)tableView
{
    ProductInfoCell *cell =  [tableView dequeueReusableCellWithIdentifier:ProductInfoCellIdentifier];
    [cell setProductItem:self.productItem];
    return cell;
}

- (UITableViewCell*) getCouponCellWithTable:(UITableView*)tableView
{
    CouponCell *cell =  [tableView dequeueReusableCellWithIdentifier:CouponCellIdentifier];
    [cell setCouponItem:self.productItem.selectCoupon];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellHeight = 80;
    switch (indexPath.row) {
        case 0:{
            cellHeight = 80; break;}
        case 1:{
            cellHeight = 120; break;}
        default:
            break;
    }
    return cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponViewController *couponViewController = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
    couponViewController.item  = self.productItem;
    [couponViewController configByProductItem];
    [self.navigationController pushViewController:couponViewController animated:YES];
}

@end
