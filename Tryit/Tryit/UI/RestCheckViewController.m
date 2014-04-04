//
//  RestCheckViewController.m
//  Tryit
//
//  Created by Mars on 3/14/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "RestCheckViewController.h"
#import "CouponListViewController.h"
#import "ProductItem.h"
#import "ProductCell.h"
#import "CheckSectionView.h"
#import "RestCheckHeaderView.h"

#import "UIFunction.h"
#import "WebAPI.h"
#import "UIImageView+AFNetworking.h"

#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

NSString *const NearRestaurantHeadSectionIdentifier = @"NearRestaurantHeadSectionIdentifier";
NSString *const ProductCellIdentifier = @"ProductCellIdentifier";
@interface RestCheckViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger selectIndex;
@property (weak, nonatomic) UILabel *filterLabel;

@end

@implementation RestCheckViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:NearRestaurantHeadSectionIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:ProductCellIdentifier];

    UIView *tableBackView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [tableBackView setBackgroundColor:UIColorFromRGB(0xF8FAF3)];
    [self.tableView setBackgroundView:tableBackView];

    self.title = self.restItem.name;
    [self customBackBarItem];

    RestCheckHeaderView *restCheckHeaderView = (RestCheckHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"RestCheckHeaderView" owner:self options:nil] lastObject];
    [restCheckHeaderView configRestItem:self.restItem];
    self.tableView.tableHeaderView = restCheckHeaderView;
    self.filterLabel = restCheckHeaderView.filterLeabl;

    WEAKSELF_SC
    restCheckHeaderView.block = ^(){
        [weakSelf_SC showFilterView];
    };
    self.selectIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.selectIndex != 0) {
        return 1;
    }
    return self.productArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (self.selectIndex == 0) {
        NSMutableArray *array = self.productArray[section];
        numberOfRows = array.count;
    }else {
        NSMutableArray *array = self.productArray[self.selectIndex-1];
        numberOfRows = array.count;
    }

    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell =  [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];

    ProductItem *item = nil;

    if (self.selectIndex == 0) {
        item = self.productArray[indexPath.section][indexPath.row];
    }else {
        item = self.productArray[self.selectIndex-1][indexPath.row];
    }

    [cell setProduct:item];

    return cell; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.selectIndex != 0) {
        section = self.selectIndex-1;
    }

    ProductItem *proItem = self.productArray[section][0];
    CheckSectionView *checkSectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NearRestaurantHeadSectionIdentifier];
    checkSectionView.nameLabel.text = proItem.type;
    return checkSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponListViewController *couponListViewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:Nil];
    ProductItem *item = Nil;
    if (self.selectIndex != 0) {
         item = self.productArray[0][indexPath.row];
    }else {
        item = self.productArray[indexPath.section][indexPath.row];
    }
    couponListViewController.productItem = item;
    [self.navigationController pushViewController:couponListViewController animated:YES];
}

#pragma mark - Filter Functions 
- (void) showFilterView
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void) selectFilterIndex:(NSInteger) index
{
    self.selectIndex = index;
    [self.tableView reloadData];
    if (index != 0) {
        ProductItem *item = self.productArray[index-1][0];
        self.filterLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_FILTERBY", nil), item.type];
    }else {
        self.filterLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_FILTERBY", nil), @"All"];
    }
}

@end
