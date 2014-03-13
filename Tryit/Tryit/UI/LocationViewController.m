//
//  LocationViewController.m
//  Tryit
//
//  Created by Mars on 3/13/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "LocationViewController.h"
#import "NearRestaurantCell.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "WebAPI.h"
#import "RestaurantAnnotation.h"

NSString *const NearRestaurantCellIdentifier = @"NearRestaurantCellIdentifier";

@interface LocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *restaurantArray;
@property (strong, nonatomic) NSMutableArray *filteredList;

@property (nonatomic) BOOL hasLocation;

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.restaurantArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.filteredList = [[NSMutableArray alloc] initWithCapacity:0];
        self.hasLocation = NO;
        self.title = NSLocalizedString(@"TITEL_NEARBY_RESTAURANTS", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.tableView registerNib:[UINib nibWithNibName:@"NearRestaurantCell" bundle:nil] forCellReuseIdentifier:NearRestaurantCellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"NearRestaurantCell" bundle:nil] forCellReuseIdentifier:NearRestaurantCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredList count];
    } else {
        return [self.restaurantArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearRestaurantCell *cell =  [tableView dequeueReusableCellWithIdentifier:NearRestaurantCellIdentifier];

    RestaurantItem *item = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        item = [self.filteredList objectAtIndex:indexPath.row];
    }else{
        item = [self.restaurantArray objectAtIndex:indexPath.row];
    }
    [cell setRestaurantItem:item];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
	[self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.filteredList removeAllObjects];

    for (RestaurantItem *item in self.restaurantArray) {
        NSComparisonResult result = [item.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredList addObject:item];
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


#pragma mark - MKMapViewDelegate 

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    if (self.hasLocation != YES) {
        double distance = 2000.0;
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.coordinate, distance, distance*195.0/320.0) animated:YES];

        [WebAPI getNearRestaurantWithCoordinate:userLocation.coordinate
                                        success:^(NSMutableArray *array) {
                                            self.restaurantArray = array;
                                            [self.tableView reloadData];
                                            [self addAnnotations];
                                        }
                                        failure:^{

                                        }];
        self.hasLocation = YES;

    }
}

- (void) addAnnotations
{
    NSArray *annotations = [self.mapView annotations];
    if (annotations.count > 0) {
        [self.mapView removeAnnotations:annotations];
    }

    for (RestaurantItem *item in self.restaurantArray) {
        RestaurantAnnotation *annnotation = [[RestaurantAnnotation alloc] initWithRestaurantItem:item];
        [self.mapView addAnnotation:annnotation];
    }

}

@end
