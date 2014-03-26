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

#import "RestaurantItem.h"
#import "ProductItem.h"
#import "CouponItem.h"

@interface WebAPI : NSObject

+ (void) getTopX:(NSInteger) topx success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getNearRestaurantWithCoordinate:(CLLocationCoordinate2D) coordinate success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getProductWithRestId:(NSString *) restId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getpromoWithProduct:(ProductItem*) item success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getRestaurantsWithUserId:(NSString*) userId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) customerCheckIn:(NSString*) userId restId:(NSString *) restId success:(void (^)())success failure:(void (^)()) failure;
@end
