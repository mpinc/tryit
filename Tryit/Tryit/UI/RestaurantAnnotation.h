//
//  RestaurantAnnotation.h
//  Tryit
//
//  Created by Mars on 3/13/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "RestaurantItem.h"
@interface RestaurantAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) RestaurantItem *restItem;

- (id) initWithRestaurantItem:(RestaurantItem*) item;

@end
