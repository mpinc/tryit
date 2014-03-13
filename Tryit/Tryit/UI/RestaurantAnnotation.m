//
//  RestaurantAnnotation.m
//  Tryit
//
//  Created by Mars on 3/13/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "RestaurantAnnotation.h"

@implementation RestaurantAnnotation

- (id) initWithRestaurantItem:(RestaurantItem*) item
{
    self = [super init];
    if (self != nil) {
        self.restItem = item;
    }
    return self;
}

- (CLLocationCoordinate2D) coordinate
{
    return CLLocationCoordinate2DMake(self.restItem.latitude, self.restItem.longitude);
}

- (NSString *) title
{
    return self.restItem.name;
}

- (NSString *)subtitle
 {
    return self.restItem.address;
}

@end
