//
//  ContactViewController.m
//  Tryit
//
//  Created by Mars on 3/4/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ContactViewController.h"

#import <AddressBook/AddressBook.h>
#import "ABWrappers.h"
#import "ABContactsHelper.h"

#import "UIFunction.h"
#import "TIContact.h"

#import "ContactCell.h"
#import "WebAPI.h"

NSString *const ContactCellIdentifier = @"ContactCellIdentifier";

@interface ContactViewController ()

@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *contactList;
@property (strong, nonatomic) NSMutableArray *filteredList;
@property (strong, nonatomic) NSMutableArray *selectArray;

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"TITLE_ADD_FRIENDS", nil);

        self.contactList = [[NSMutableArray alloc] initWithCapacity:0];
        self.filteredList = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.contactTableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:ContactCellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:ContactCellIdentifier];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contactTableView.bounds];
    [imageView setImage:[UIImage imageNamed:@"common_bg"]];
    [self.contactTableView setBackgroundView:imageView];

    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:self.contactTableView.bounds];
    [imageView1 setImage:[UIImage imageNamed:@"common_bg"]];
    [self.searchDisplayController.searchResultsTableView setBackgroundView:imageView1];

    self.contactTableView.sectionIndexTrackingBackgroundColor = UIColorFromRGB(0xd4e19b);

    if (IsIOS7) {
        [self.contactTableView setSeparatorInset:UIEdgeInsetsZero];
    }

    // Do any additional setup after loading the view from its nib.
    [self initAddressBook];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:NSLocalizedString(@"TITLE_SEND", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchSendButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barItem;

    [self customBackBarItem];

    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"bg_search"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initAddressBook
{
    WEAKSELF_SC
    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
    [[NSNotificationCenter defaultCenter] addObserverForName:kAuthorizationUpdateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         NSNumber *granted = note.object;
         [weakSelf_SC enableGUI:granted.boolValue];
     }];
    [ABStandin requestAccess];
}

- (void) enableGUI:(BOOL) yorn
{
    if (yorn)
    {
        WEAKSELF_SC
        dispatch_async(dispatch_get_main_queue(), ^{

            NSMutableArray *tempContacts = [NSMutableArray arrayWithArray:[ABContactsHelper contactsWithOrder]];
            NSMutableArray *tempTableItems = [NSMutableArray arrayWithCapacity:tempContacts.count];

            // get All Data
            for (int i = 0; i<tempContacts.count; i++) {
                ABContact *contact = (ABContact*) tempContacts[i];
                if (contact.emailArray.count > 0) {
                    TIContact *tiContact = [[TIContact alloc] initWithContact:contact];
                    [tempTableItems addObject:tiContact];
                }
            }

            // Sort data
            UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];

            // Thanks Steph-Fongo!
            SEL sorter = ABPersonGetSortOrdering() == kABPersonSortByFirstName ? NSSelectorFromString(@"contactName") : NSSelectorFromString(@"contactName");

            for (TIContact *contact in tempTableItems) {
                NSInteger sect = [theCollation sectionForObject:contact
                                        collationStringSelector:sorter];
                contact.sectionNumber = sect;
            }

            NSInteger highSection = [[theCollation sectionTitles] count];
            NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
            for (int i=0; i<=highSection; i++) {
                NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
                [sectionArrays addObject:sectionArray];
            }

            for (TIContact *contact in tempTableItems) {
                [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
            }

            for (NSMutableArray *sectionArray in sectionArrays) {
                NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:sorter];
                [self.contactList addObject:sortedSection];
            }

            DLog(@"%@", self.contactList);

            [weakSelf_SC.contactTableView reloadData];
            [UIFunction removeMaskView];
        });
    }else {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CONTACTS_AUTHORITY", nil)];
    }
}


#pragma mark - Button Action

-(void) touchSendButton
{
    if (self.selectArray.count > 0) {
        NSString *emailList = @"";
        for (TIContact *contact in self.selectArray) {
           emailList = [emailList stringByAppendingFormat:@",%@", contact.email];
        }
        self.ccItem.emailList = emailList;
        [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", Nil)];
        [WebAPI createCouponWithCCItem:self.ccItem success:^{
            [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_SHARE_SUCCESS", nil)];
            [self.navigationController popViewControllerAnimated:YES];
            [UIFunction removeMaskView];
        } failure:^{
            [UIFunction removeMaskView];
        }];
    }else {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_SHARE_FIREND_NULL", nil)];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
	} else {
        return [self.contactList count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredList count];
    } else {
        return [[self.contactList objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell =  (ContactCell*)[tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier];

	TIContact *contact = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        contact = (TIContact *)[self.filteredList objectAtIndex:indexPath.row];
    }else{
        contact = (TIContact *)[[self.contactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }

    [cell setContact:contact];

    WEAKSELF_SC
    ChangeContact changeContact = ^(TIContact *changeContact){
        if (changeContact.isSelected && ![weakSelf_SC.selectArray containsObject:changeContact]) {
            [weakSelf_SC.selectArray addObject:changeContact];
        }else {
            [weakSelf_SC.selectArray removeObject:changeContact];
        }

        if (weakSelf_SC.selectArray.count > 0) {
            weakSelf_SC.title = [NSString stringWithFormat:NSLocalizedString(@"FORMAT_TITLE_ADD_FRIENDS", nil), weakSelf_SC.selectArray.count];
        }else {
            weakSelf_SC.title = NSLocalizedString(@"TITLE_ADD_FRIENDS", nil);
        }
    };

    cell.changeContact = changeContact;

    return cell;
}

#pragma mark - index

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return nil;
//    } else {
//        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
//                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//    }
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return 0;
//    } else {
//        if (title == UITableViewIndexSearch) {
//            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
//            return -1;
//        } else {
//            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
//        }
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return nil;
//    } else {
//        return [[self.contactList objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
//    }
//}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
	[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.contactTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.contactTableView reloadData];
}

#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.filteredList removeAllObjects];
    for (NSArray *section in self.contactList) {
        for (TIContact *contact in section)
        {
            BOOL needAdd = NO;
            NSComparisonResult nameResult = [contact.contactName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (nameResult == NSOrderedSame)
            {
                needAdd = YES;
            }
            NSComparisonResult emailResult = [contact.email compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (emailResult == NSOrderedSame)
            {
                needAdd = YES;
            }
            if (needAdd == YES) {
                [self.filteredList addObject:contact];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

@end
