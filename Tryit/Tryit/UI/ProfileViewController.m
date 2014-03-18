//
//  ProfileViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProfileViewController.h"
#import "RestaurantItem.h"
#import "UserRestCell.h"
#import "ProfileInfoView.h"
#import "UIFunction.h"
#import "WebAPI.h"
NSString *const UserRestCellIdentifier = @"UserRestCellIdentifier";

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *restArray;

@end

@implementation ProfileViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"UserRestCell" bundle:nil] forCellReuseIdentifier:UserRestCellIdentifier];

    ProfileInfoView *profileInfoView = (ProfileInfoView*)[[[NSBundle mainBundle] loadNibNamed:@"ProfileInfoView" owner:self options:nil] lastObject];
    self.tableView.tableHeaderView = profileInfoView;

    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
    WEAKSELF_SC
    [WebAPI getRestaurantsWithUserId:@"" success:^(NSMutableArray *array) {
        weakSelf_SC.restArray = [NSMutableArray arrayWithArray:array];
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
    return self.restArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserRestCell *cell =  [tableView dequeueReusableCellWithIdentifier:UserRestCellIdentifier];

    RestaurantItem *item = [self.restArray objectAtIndex:indexPath.row];

    [cell setRestaurantItem:item];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
