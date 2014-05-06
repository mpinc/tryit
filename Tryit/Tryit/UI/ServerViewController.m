//
//  ServerViewController.m
//  eDianche
//
//  Created by Mars on 13-4-16.
//  Copyright (c) 2013年 SKTLab. All rights reserved.
//

#import "ServerViewController.h"
#import "UIFunction.h"
#import "AppDelegate.h"
#import "NSString+Utlity.h"
@interface ServerViewController ()

@end

@implementation ServerViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.serverAddressTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        self.serverAddressTextView.delegate = self;
        [self.serverAddressTextView setFont:[UIFont systemFontOfSize:17]];
        [self.serverAddressTextView setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:self.serverAddressTextView];

        UIImage *rightButtonImage = [[UIImage imageNamed:@"navbg_green"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(changeServerAddress)];
        [rightButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = rightButton;

        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
        [leftButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = leftButton;

        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 400)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];

        self.serverDict = @{@"EC2":@"http://54.186.250.135:8080/",@"US":@"http://192.168.1.7:8080/", @"XI'AN":@"http://192.168.1.206:8080/"};
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mainServerAddress = [userDefaults objectForKey:BaseAddress];
    if (mainServerAddress == nil) {
        self.serverAddressTextView.text = BaseURL;
    }else {
        self.serverAddressTextView.text = mainServerAddress;
    }
    [UIFunction removeMaskView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeServerAddress {
    if (![NSString isEmptyString:self.serverAddressTextView.text]) {
        NSString *message = [NSString stringWithFormat:@"你确定要把服务器地址改为%@么？", self.serverAddressTextView.text];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MAIN_TITLE", nil) message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alertView show];
    }
}

- (void) dismissSelf{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        AppDelegate *appDelegate = [AppDelegate getAppdelegate];
        [appDelegate setPopServerViewController:NO];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.serverAddressTextView.text forKey:BaseAddress];
        [userDefaults synchronize];
        AppDelegate *appDelegate = [AppDelegate getAppdelegate];
        appDelegate.baseAddress = self.serverAddressTextView.text;
        appDelegate.serverAddress = nil;
        [appDelegate removeUserInfo];
        [self dismissSelf];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.serverDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SettingViewTableCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
    cell.textLabel.numberOfLines = 0;

    NSArray *serverLabels = [self.serverDict allKeys];

    cell.textLabel.text = [serverLabels objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.serverDict objectForKey:cell.textLabel.text];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *serverLabels = [self.serverDict allKeys];

    NSString *labelString = [serverLabels objectAtIndex:indexPath.row];
    
    NSString *serverAddress = [self.serverDict objectForKey:labelString];
    if (serverAddress != nil) {
        self.serverAddressTextView.text = serverAddress;
        [self changeServerAddress];
    }
}

@end
