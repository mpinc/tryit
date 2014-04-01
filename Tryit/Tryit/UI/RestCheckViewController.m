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

NSString *const NearRestaurantHeadSectionIdentifier = @"NearRestaurantHeadSectionIdentifier";
NSString *const ProductCellIdentifier = @"ProductCellIdentifier";
@interface RestCheckViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *productArray;

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

    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
    WEAKSELF_SC
    [WebAPI getProductWithRestId:self.restItem.biz_id success:^(NSMutableArray *array) {
        weakSelf_SC.productArray = [NSMutableArray arrayWithArray:array];
        [weakSelf_SC.tableView reloadData];
        self.restItem.productArray = weakSelf_SC.productArray;
        [UIFunction removeMaskView];
    } failure:^{
        [UIFunction removeMaskView];
    }];

    self.title = self.restItem.name;
    [self customBackBarItem];

    RestCheckHeaderView *restCheckHeaderView = (RestCheckHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"RestCheckHeaderView" owner:self options:nil] lastObject];
    [restCheckHeaderView configRestItem:self.restItem];
    self.tableView.tableHeaderView = restCheckHeaderView;
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
    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell =  [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];

    ProductItem *item = [self.productArray objectAtIndex:indexPath.row];

    [cell setProduct:item];

    return cell; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CheckSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NearRestaurantHeadSectionIdentifier];
    [headerView setRestItem:self.restItem];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponListViewController *couponListViewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:Nil];
    ProductItem *item = [self.productArray objectAtIndex:indexPath.row];
    couponListViewController.productItem = item;
    [self.navigationController pushViewController:couponListViewController animated:YES];
}

@end
