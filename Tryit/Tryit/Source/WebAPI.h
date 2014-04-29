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

// account
+ (void) signUpWithPassword:(NSString *) password email:(NSString *) email success:(void (^)(id responseObject))success failure:(void (^)()) failure;
+ (void) loginWithUserName:(NSString *) userName Password:(NSString *) password success:(void (^)(id responseObject))success failure:(void (^)()) failure;
+ (void) restPasswrodWithEmail:(NSString *) email success:(void (^)(id responseObject))success failure:(void (^)()) failure;
+ (void) activeAccountWithEmail:(NSString *) email success:(void (^)(id responseObject))success failure:(void (^)()) failure;
+ (void) changePasswrodWithOldPassword:(NSString *) oldPassword replacePassword:(NSString *) replacePassword success:(void (^)(id responseObject))success failure:(void (^)()) failure;

// top dish
+ (void) getTopXWithCoordinate:(CLLocationCoordinate2D) coordinate success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getNearRestaurantWithCoordinate:(CLLocationCoordinate2D) coordinate success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;

// rest info
+ (void) getRestaurantWithBizId:(NSString*) bizId success:(void (^)(RestaurantItem *item))success failure:(void (^)()) failure;
+ (void) getProductWithRestId:(NSString *) restId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getpromoWithProduct:(ProductItem*) item success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;

// user info
+ (void) getRestaurantsSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) getUserPorfileSuccess:(void (^)(UserProfile *userProfile))success failure:(void (^)()) failure;
+ (void) getUserShareRestaurantID:(NSString*) bizId WithSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure;
+ (void) customerCheckIn:(NSString*) userId restId:(NSString *) restId success:(void (^)())success failure:(void (^)()) failure;

+ (void) createCouponWithCCItem:(CreateCouponItem*) ccItem success:(void (^)())success failure:(void (^)()) failure;

+ (NSURL*) getImageURL:(NSString*) imageString;

@end
