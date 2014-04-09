//
//  LocationViewController.m
//  Tryit
//
//  Created by Mars on 3/13/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "LocationViewController.h"
#import "RestCheckViewController.h"
#import "NearRestaurantCell.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "WebAPI.h"
#import "RestaurantAnnotation.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "FilterViewController.h"
#import "UIFunction.h"

NSString *const NearRestaurantCellIdentifier = @"NearRestaurantCellIdentifier";

@interface LocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *restaurantArray;
@property (strong, nonatomic) NSMutableArray *filteredList;

@property (strong, nonatomic) RestaurantItem *selectItem;

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
        self.title = NSLocalizedString(@"TITLE_NEARBY_RESTAURANTS", nil);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.tableView registerNib:[UINib nibWithNibName:@"NearRestaurantCell" bundle:nil] forCellReuseIdentifier:NearRestaurantCellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"NearRestaurantCell" bundle:nil] forCellReuseIdentifier:NearRestaurantCellIdentifier];
    [self.mapView setShowsUserLocation:YES];

    self.searchDisplayController.delegate = self;
    self.searchBar.delegate = self;

    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"bg_search"]];

    [self customBackBarItem];

    if (IsIOS7) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantItem *item = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        item = [self.filteredList objectAtIndex:indexPath.row];
    }else{
        item = [self.restaurantArray objectAtIndex:indexPath.row];
    }
    [self loadRestCheckVCWithItem:item];
}

- (void) loadRestCheckVCWithItem:(RestaurantItem*) item
{
    [UIFunction showWaitingAlertWithString:NSLocalizedString(@"PROMPT_LODING", nil)];
    [WebAPI getProductWithRestId:item.biz_id success:^(NSMutableArray *array) {
        [self perparRestCheckVC:item WithArray:array];
        [UIFunction removeMaskView];
    } failure:^{
        [self perparRestCheckVC:item WithArray:nil];
        [UIFunction removeMaskView];
    }];
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)m_searchBar
{
	[self.searchDisplayController.searchBar setShowsCancelButton:YES];
    for (UIView *searchbuttons in self.searchBar.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            cancelButton.enabled = YES;
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"bg_search"] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"bg_search"] forState:UIControlStateHighlighted];
            break;
        }
    }

    if (!m_searchBar.window.isKeyWindow){
        [m_searchBar.window makeKeyAndVisible];
    }
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
        NSRange range = [item.name rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
        if (range.length != NSOrderedSame)
        {
            [self.filteredList addObject:item];
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

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
        [UIFunction removeMaskView];
        double distance = 10000.0;
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.coordinate, distance, distance*195.0/320.0) animated:YES];
        WEAKSELF_SC
        [WebAPI getNearRestaurantWithCoordinate:userLocation.coordinate
                                        success:^(NSMutableArray *array) {

                                            NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                NSComparisonResult result = NSOrderedSame;
                                                RestaurantItem *item1 = (RestaurantItem*) obj1;
                                                RestaurantItem *item2 = (RestaurantItem*) obj2;
                                                if (item1.distance < item2.distance) {
                                                    result = NSOrderedAscending;
                                                }else {
                                                    result= NSOrderedDescending;
                                                }
                                                return result;
                                            }];

                                            weakSelf_SC.restaurantArray = [NSMutableArray arrayWithArray:sortArray];
                                            [weakSelf_SC.tableView reloadData];
                                            [weakSelf_SC addAnnotations];
                                        }
                                        failure:^{

                                        }];
        self.hasLocation = YES;

    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RestaurantAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"searchAnnotation"];
        annotationView.image = [UIImage imageNamed:@"annotation"];
        annotationView.canShowCallout = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = button;
        [button addTarget:self action:@selector(touchInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        return annotationView;
    }
    return nil;
}

- (void)touchInfoButton:(id) sender
{
    if (self.selectItem != nil) {
        [self loadRestCheckVCWithItem:self.selectItem];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    RestaurantAnnotation *annotation = (RestaurantAnnotation*) view.annotation;
    RestaurantItem *item = annotation.restItem;

    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[self.restaurantArray indexOfObject:item] inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    self.selectItem = item;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    self.selectItem = nil;
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

#pragma mark - prepar rest check view controller 

- (void) perparRestCheckVC:(RestaurantItem*) item WithArray:(NSArray*) array;
{
    RestCheckViewController *restCheckViewController = [[RestCheckViewController alloc] initWithNibName:@"RestCheckViewController" bundle:nil];
    FilterViewController *filterViewController = [[FilterViewController alloc] initWithNibName:@"RestCheckViewController" bundle:nil];
    restCheckViewController.restItem = item;
    filterViewController.delegate = restCheckViewController;

    if (array != nil) {
        NSMutableArray *productsArray = [[NSMutableArray alloc] initWithCapacity:0]; // save section array
        NSMutableArray *filterArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableDictionary *filterDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (ProductItem *proItem in array) {
            NSString *type = proItem.type;
            NSMutableArray *productArray = [filterDict objectForKey:type];
            if (productArray == Nil) {
                productArray = [[NSMutableArray alloc] initWithCapacity:0];
                [productsArray addObject:productArray];
                [filterArray addObject:proItem.type];
                [filterDict setObject:productArray forKey:type];
            }
            [productArray addObject:proItem];
        }

        restCheckViewController.productArray = productsArray;

        [filterArray insertObject:@"All" atIndex:0];
        filterViewController.filterArray = filterArray;
    }

    MMDrawerController *mmDrawerController = [[MMDrawerController alloc] initWithCenterViewController:restCheckViewController rightDrawerViewController:filterViewController];
    [mmDrawerController setRestorationIdentifier:@"MMDrawer"];
    [mmDrawerController setMaximumRightDrawerWidth:150.0];
    [mmDrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [mmDrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    mmDrawerController.title = item.name;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [button addTarget:self action:@selector(touchBackbutton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"navback"] forState:UIControlStateNormal];

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    mmDrawerController.navigationItem.leftBarButtonItem = leftButtonItem;

    [self.navigationController pushViewController:mmDrawerController animated:YES];

    item.productArray = restCheckViewController.productArray;
}

- (void) touchBackbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
