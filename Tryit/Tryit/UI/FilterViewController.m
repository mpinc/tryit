//
//  FilterViewController.m
//  Tryit
//
//  Created by Mars on 4/1/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "FilterViewController.h"


#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

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
    // Do any additional setup after loading the view from its nib.
    self.tableView.separatorColor = UIColorFromRGB(0x555555);

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0x555555);
    if (IsIOS7) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.contentView setBackgroundColor:UIColorFromRGB(0x403F3F)];

        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
        [cell.textLabel setHighlightedTextColor:UIColorFromRGB(0x92C958)];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    cell.textLabel.text = [self.filterArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSIndexPath *indexpathForEach in [tableView indexPathsForVisibleRows]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexpathForEach];
        if (indexPath.row != indexpathForEach.row) {
            [cell.textLabel setHighlighted:NO];
        }else{
            [cell.textLabel setHighlighted:YES];
        }
    }

    if (indexPath.row != 0) {
        [self.delegate selectFilterIndex:indexPath.row-1];
    }else{
        [self.delegate selectFilterIndex:indexPath.row];
    }
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

@end
