//
//  WebAPI.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "WebAPI.h"
#import "UIFunction.h"

#define BaseURL @"http://0.0.0.0:8080"

@implementation WebAPI

+ (AFHTTPRequestOperationManager *) getManager
{
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    });
    return manager;
}

+ (void) getNearRestaurantWithCoordinate:(CLLocationCoordinate2D) coordinate success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    [[WebAPI getManager] GET:@"/biz" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *restDict in responseObject) {
            RestaurantItem * item = [[RestaurantItem alloc] initWithDict:restDict];
            [array addObject:item];
        }
        DLog(@"array:%@", array);
        success(array);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        failure();
    }];
}

+ (void) getProductWithRestId:(NSString *) restId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/biz/%@/prod", restId];
    [[WebAPI getManager] GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *restDict in responseObject) {
            ProductItem *item = [[ProductItem alloc] initWithDict:restDict];
            [array addObject:item];
        }
        DLog(@"array:%@", array);
        success(array);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        failure();
    }];
}

+ (void) getpromoWithProduct:(ProductItem*) item success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/biz/%@/prod/%@/promo", item.biz_id, item.prod_id];
    [[WebAPI getManager] GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *restDict in responseObject) {
            CouponItem *item = [[CouponItem alloc] initWithDict:restDict];
            [array addObject:item];
        }
        DLog(@"array:%@", array);
        success(array);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        failure();
    }];
}

+ (void) getRestaurantsWithUserId:(NSString*) userId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/cust/100001/biz"];
    [[WebAPI getManager] GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        DLog(@"%@", operation);
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *restDict in responseObject) {
            RestaurantItem *item = [[RestaurantItem alloc] initWithDict:restDict];
            [array addObject:item];
        }
        DLog(@"array:%@", array);
        success(array);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        failure();
    }];
}

+ (void) customerCheckIn:(NSString*) userId restId:(NSString *) restId success:(void (^)())success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/cust/%@/biz/%@/checkin", userId, restId];
    [[WebAPI getManager] POST:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        DLog(@"%@", operation);
        success();

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
        failure();
    }];
}

@end
