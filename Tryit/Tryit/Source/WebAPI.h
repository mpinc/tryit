//
//  WebAPI.h
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

@interface WebAPI : NSObject

+ (void) getNearRestaurantWithCoordinate:(CLLocationCoordinate2D) coordinate success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getProductWithRestId:(NSString *) restId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;

@end
