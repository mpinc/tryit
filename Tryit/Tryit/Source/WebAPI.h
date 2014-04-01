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
#import "CreateCouponItem.h"
#import "UserProfile.h"
#import "ShareItem.h"

@interface WebAPI : NSObject
+ (AFHTTPRequestOperationManager *) getManager;

+ (void) signUpWithUserName:(NSString *) userName Password:(NSString *) password email:(NSString *) email success:(void (^)(id responseObject))success failure:(void (^)()) failure;
+ (void) loginWithUserName:(NSString *) userName Password:(NSString *) password success:(void (^)(id responseObject))success failure:(void (^)()) failure;

+ (void) getTopX:(NSInteger) topx success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getNearRestaurantWithCoordinate:(CLLocationCoordinate2D) coordinate success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getProductWithRestId:(NSString *) restId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getpromoWithProduct:(ProductItem*) item success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getRestaurantsSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getUserPorfileSuccess:(void (^)(UserProfile *userProfile))success failure:(void (^)()) failure;
+ (void) getUserShareRestaurantID:(NSString*) bizId WithSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) customerCheckIn:(NSString*) userId restId:(NSString *) restId success:(void (^)())success failure:(void (^)()) failure;

+ (void) createCouponWithCCItem:(CreateCouponItem*) ccItem success:(void (^)())success failure:(void (^)()) failure;
@end
