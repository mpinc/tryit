//
//  ProfileViewController.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserRestViewController.h"
#import "RestaurantItem.h"
#import "UserRestCell.h"
#import "ProfileInfoView.h"
#import "UIFunction.h"
#import "WebAPI.h"
#import "AppDelegate.h"
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

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 28)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:NSLocalizedString(@"TITLE_LOGOUT", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchLogOutButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barItem;

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    [bgImageView setImage:[UIImage imageNamed:@"food_bg"]];
    [self.tableView setBackgroundView:bgImageView];
}

- (void) viewDidAppear:(BOOL)animated
{
    WEAKSELF_SC
    [WebAPI getUserPorfileSuccess:^(UserProfile *up) {
        if (up != nil) {
            self.userProfile = up;
            ProfileInfoView *profileInfoView = (ProfileInfoView*)[[[NSBundle mainBundle] loadNibNamed:@"ProfileInfoView" owner:self options:nil] lastObject];
            profileInfoView.userProfile = self.userProfile;
            self.tableView.tableHeaderView = profileInfoView;
        }
        [UIFunction removeMaskView];
    } failure:^{
        [UIFunction removeMaskView];
    }];

    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
    [WebAPI getRestaurantsSuccess:^(NSMutableArray *array) {
        weakSelf_SC.restArray = [NSMutableArray arrayWithArray:array];
        self.userProfile.vipRest = [NSString stringWithFormat:@"%lu", (unsigned long)array.count];
        ProfileInfoView *profileView = (ProfileInfoView*)self.tableView.tableHeaderView;
        profileView.userProfile = self.userProfile;
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

#pragma mark - UITableViewDataSource & UITableViewDelegate

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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantItem *item = [self.restArray objectAtIndex:indexPath.row];
    UserRestViewController *userRestViewController = [[UserRestViewController alloc] initWithNibName:@"UserRestViewController" bundle:nil];
    userRestViewController.restaurantItem = item;
    [self.navigationController pushViewController:userRestViewController animated:YES];
}

#pragma mark - Button Action

- (void) touchLogOutButton
{
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    [appDelegate removeUserInfo];
    [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_LOGOUT_SUCCESS", nil)];
}

@end
