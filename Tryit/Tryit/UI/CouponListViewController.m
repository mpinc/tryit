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
#import "IngredientInfoCell.h"
#import "SingleInfoCell.h"
#import "WebAPI.h"
#import "UIFunction.h"
#import "AppDelegate.h"
#import "NSString+Utlity.h"

NSString *const ProductInfoCellIdentifier = @"ProductInfoCellIdentifier";
NSString *const CouponCellIdentifier = @"CouponCellIdentifier";
NSString *const IngredientInfoCellIdentifier = @"IngredientInfoCellIdentifier";
NSString *const SingleInfoCellIdentifier = @"SingleInfoCellIdentifier";

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

    // product cell
    self.itemArray = [NSMutableArray arrayWithObjects:ProductInfoCellIdentifier, nil];
    // Ingredient cell
    if (![NSString isEmptyString:self.productItem.ingredients]) {
        [self.itemArray addObject:IngredientInfoCellIdentifier];
    }
    // calaries cell
    if (self.productItem.calaries > 0) {
        [self.itemArray addObject:SingleInfoCellIdentifier];
    }
    // spiciness scale cell
    [self.itemArray addObject:SingleInfoCellIdentifier];

    [self.tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:ProductInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:CouponCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"IngredientInfoCell" bundle:nil] forCellReuseIdentifier:IngredientInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SingleInfoCell" bundle:nil] forCellReuseIdentifier:SingleInfoCellIdentifier];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 213)];
    [imageView fixSetImageWithURL:self.productItem.img_url placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.tableView.tableHeaderView = imageView;

//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
//    [bgImageView setImage:[UIImage imageNamed:@"food_bg"]];
//    [self.tableView setBackgroundView:bgImageView];

    WEAKSELF_SC
    [WebAPI getpromoWithProduct:self.productItem success:^(NSMutableArray *array) {
        CouponItem *couponItem = (CouponItem*)[array lastObject];
        if (couponItem != nil) {
            weakSelf_SC.productItem.selectCoupon = couponItem;
            [weakSelf_SC.itemArray insertObject:CouponCellIdentifier atIndex:1];
            [weakSelf_SC.tableView reloadData];
        }
    } failure:^{
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
    NSString *identifier = self.itemArray[indexPath.row];

    if ([identifier isEqualToString:ProductInfoCellIdentifier]) {
        cell = [self getProductInfoCellWithTable:tableView];
    }else if([identifier isEqualToString:CouponCellIdentifier]){
        cell = [self getCouponCellWithTable:tableView];
    }else if([identifier isEqualToString:IngredientInfoCellIdentifier]){
        cell = [self getIngredientInfoCellWithTable:tableView];
    }else {
        cell = [self getSingleInfoCellWithTable:tableView WithIndexPath:indexPath];
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

- (UITableViewCell*) getIngredientInfoCellWithTable:(UITableView*)tableView
{
    IngredientInfoCell *cell =  [tableView dequeueReusableCellWithIdentifier:IngredientInfoCellIdentifier];
    [cell setIngredientInfo:self.productItem];
    return cell;
}

// if this cell is last one, must be Spiciness scale cell
- (UITableViewCell*) getSingleInfoCellWithTable:(UITableView*)tableView WithIndexPath:(NSIndexPath *) indexPath
{
    SingleInfoCell *cell =  [tableView dequeueReusableCellWithIdentifier:SingleInfoCellIdentifier];

    if (indexPath.row == (self.itemArray.count-1)) {
        [cell setSpicinessScaleInfo:self.productItem];
    }else {
        [cell setCalariesInfo:self.productItem];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identifier = self.itemArray[indexPath.row];

    int cellHeight = 44;

    if ([identifier isEqualToString:ProductInfoCellIdentifier]) {
        cellHeight = 70;
    }else if([identifier isEqualToString:CouponCellIdentifier]){
        cellHeight = 100;
    }else if([identifier isEqualToString:IngredientInfoCellIdentifier]){
        cellHeight = 70;
    }else {
        cellHeight = 44;
    }
    cellHeight = cellHeight + [self getFixHeightForIndexPath:indexPath];
    return cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        CouponViewController *couponViewController = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
        couponViewController.item  = self.productItem;
        [couponViewController configByProductItem];
        [self.navigationController pushViewController:couponViewController animated:YES];
    }
}

- (int) getFixHeightForIndexPath:(NSIndexPath *) indexPath
{
    NSString *identifier = self.itemArray[indexPath.row];
    float fixheight = 0;
    NSString *fixString = nil;
    if ([identifier isEqualToString:ProductInfoCellIdentifier]) {
        fixString = self.productItem.description;
    }else if ([identifier isEqualToString:CouponCellIdentifier]) {
        fixString = self.productItem.selectCoupon.couPonDescription;
    }else if ([identifier isEqualToString:IngredientInfoCellIdentifier]) {
        fixString = self.productItem.ingredients;
    }

    CGSize stringSize = CGSizeZero;
    if ([identifier isEqualToString:CouponCellIdentifier]) {
        stringSize = [self getStringHeiWithString:fixString Width:267];
    }else {
        stringSize = [self getStringHeiWithString:fixString Width:300];
    }
    if (stringSize.height > 20) {
        fixheight = stringSize.height - 20;
    }
    return fixheight;
}

- (CGSize) getStringHeiWithString:(NSString *)string Width:(float) width
{
    CGSize stringSize = [string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width, 300)];
    return stringSize;
}

@end
