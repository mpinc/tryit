//
//  RestCheckHeaderView.m
//  Tryit
//
//  Created by Mars on 4/1/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "RestCheckHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "UIButtonExt.h"
#import "AppDelegate.h"
#import "WebAPI.h"
#import "UIFunction.h"
#import <MapKit/MapKit.h>
#import "NSString+Utlity.h"
@implementation RestCheckHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) configRestItem:(RestaurantItem*) item
{
    /*
     @property (nonatomic, strong) NSString *biz_id;
     @property (nonatomic, strong) NSString *name;
     @property (nonatomic, strong) NSString *address;
     @property (nonatomic, strong) NSString *phone_no;
     @property (nonatomic, strong) NSURL *restaurantImageUrl;
     @property (nonatomic, strong) NSString *point;
     @property (nonatomic, strong) NSMutableArray *productArray;
     @property (nonatomic, strong) NSArray *couponArray;
     @property (nonatomic) float distance;
     @property (nonatomic) float latitude;
     @property (nonatomic) float longitude;
     */
    self.restItem = item;
    if (item.restaurantImageUrl != nil) {
        [self.restImageView setImageWithURL:item.restaurantImageUrl placeholderImage:[UIImage imageNamed:@"default_image"]];
    }

    self.restNameLabel.text = item.name;

    [self.locationButton setTitle:item.address forState:UIControlStateNormal];
    self.locationButton.titleLabel.numberOfLines = 0;
    [self.locationButton leftImageAndRightTitle:5];

    [self.phoneButton setTitle:item.phone_no forState:UIControlStateNormal];
    [self.phoneButton leftImageAndRightTitle:5];
    
    [self.changeButton rightImageAndLeftTitle:10];

    self.statusLabel.layer.cornerRadius = 5.0;
    self.checkInButton.layer.cornerRadius = 5.0;

    if (item.isOpen) {
        self.statusLabel.text = NSLocalizedString(@"PROMPT_OPEN_STATUS", nil);
    }else{
        self.statusLabel.text = NSLocalizedString(@"PROMPT_CLOSE_STATUS", nil);
    }
}

- (IBAction)touchCheckInButton:(id)sender {

    AppDelegate *appDelegate = [AppDelegate getAppdelegate];

    [WebAPI customerCheckIn:appDelegate.userId restId:self.restItem.biz_id success:^{
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_IN_SUCCESS", nil)];
    } failure:^{
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_CHECK_IN_FAIL", nil)];
    }];
}

- (IBAction)touchLocationButton:(id)sender {
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(self.restItem.latitude, self.restItem.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

- (IBAction)touchPhoneButton:(id)sender {
    [self.restItem.phone_no callPhoneNumber];
}

- (IBAction)touchChangeButton:(id)sender {

    self.block();
}

@end
