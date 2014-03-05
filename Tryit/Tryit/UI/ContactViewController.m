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

@interface ContactViewController ()

@property (weak, nonatomic) IBOutlet UITableView *contactTableView;

@property (strong, nonatomic) NSMutableArray *contactList;
@property (strong, nonatomic) NSMutableArray *filteredList;

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"TITEL_ADD_FRIENDS", nil);

        self.contactList = [[NSMutableArray alloc] initWithCapacity:0];
        self.filteredList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initAddressBook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initAddressBook
{
    WEAKSELF_SC
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
            [UIFunction showWaitingAlertWithString:NSLocalizedString(@"DATA_LOADING", nil)];
            NSMutableArray *tempContacts = [NSMutableArray arrayWithArray:[ABContactsHelper contactsWithOrder]];
            NSMutableArray *tempTableItems = [NSMutableArray arrayWithCapacity:tempContacts.count];

            // get All Data
            for (int i = 0; i<tempContacts.count; i++) {
                ABContact *contact = (ABContact*) tempContacts[i];

                TIContact *tiContact = [[TIContact alloc] initWithContact:contact];
                [tempTableItems addObject:tiContact];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

	TIContact *contact = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        contact = (TIContact *)[self.filteredList objectAtIndex:indexPath.row];
    }else{
        contact = (TIContact *)[[self.contactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = contact.contactName;
    cell.detailTextLabel.text = contact.email;
    [cell.imageView setImage:contact.image];

    return cell;
}

#pragma mark - index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[self.contactList objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

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
            NSComparisonResult result = [contact.contactName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
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



@end
