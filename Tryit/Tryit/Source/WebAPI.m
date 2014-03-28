//
//  WebAPI.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "WebAPI.h"
#import "UIFunction.h"
#import "AppDelegate.h"

#define MPOST @"POST"
#define MGET @"GET"

#define TIMEOUT 15

@implementation WebAPI

+ (AFHTTPRequestOperationManager *) getManager
{
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        AppDelegate *appDelegate = [AppDelegate getAppdelegate];

        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:appDelegate.baseAddress]];
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [manager setRequestSerializer:serializer];

        NSOperationQueue *operationQueue = manager.operationQueue;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            DLog(@"Made it here.");

            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    DLog(@"Reachable");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    DLog(@"Not Reachable");
                    break;
            }
        }];
    });
    return manager;
}

+ (void) errorPrompt:(AFHTTPRequestOperation *)operation Error:(NSError *)error
{
    DLog(@"Error: %@", operation.responseObject);
    NSDictionary *dict = (NSDictionary *) operation.responseObject;
    if (dict[@"message"]) {
        [UIFunction showAlertWithMessage:dict[@"message"]];
    }
    else if(error.code == -1001)
    {
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_REQUEST_TIMEOUT", nil)];
    }
    else{
        [UIFunction showAlertWithMessage:NSLocalizedString(@"PROMPT_NOT_CONNECT_SERVER", nil)];
    }
}

+ (void) request:(NSString *) path
      parameters:(NSDictionary *)parameters
          Method:(NSString*) method
       NeedToken:(BOOL) needToken
         success:(void (^)(AFHTTPRequestOperation *operation))success
         failure:(void (^)(AFHTTPRequestOperation *operation))failure
{
    AFHTTPRequestOperationManager *manager = [WebAPI getManager];

    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:TIMEOUT];


    if (needToken) {
        AppDelegate *appDelegate = [AppDelegate getAppdelegate];
        if ([appDelegate getAccessToken] == nil) {
            return;
        }else {
            [request addValue:[appDelegate getAccessToken] forHTTPHeaderField:accessToken];
        }
    }

    DLog(@"%@", request);
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        success(operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WebAPI errorPrompt:operation Error:error];
        failure(operation);
    }];

    [manager.operationQueue addOperation:operation];
}

+ (void) loginWithUserName:(NSString *) userName Password:(NSString *) password success:(void (^)(id responseObject))success failure:(void (^)()) failure
{
    NSString *requestString = @"/cust/to/doLogin";
    NSDictionary *dict = @{@"user":userName,@"password":password};
    [WebAPI request:requestString parameters:dict Method:MPOST NeedToken:NO
            success:^(AFHTTPRequestOperation *operation) {
                success(operation.responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
}

+ (void) signUpWithUserName:(NSString *) userName Password:(NSString *) password email:(NSString *) email success:(void (^)(id responseObject))success failure:(void (^)()) failure
{
    NSString *requestString = @"/cust/";
    NSDictionary *dict = @{@"user":userName, @"email":email, @"password":password, @"active":@"1"};
    [WebAPI request:requestString parameters:dict Method:MPOST NeedToken:NO
            success:^(AFHTTPRequestOperation *operation) {
                success(operation.responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
}

+ (void) getTopX:(NSInteger) topx success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/biz/%d/topDish", topx];
    [WebAPI request:requestString parameters:nil Method:MGET NeedToken:NO
            success:^(AFHTTPRequestOperation *operation) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *restDict in operation.responseObject) {
                    ProductItem *item = [[ProductItem alloc] initWithDict:restDict];
                    [array addObject:item];
                }
                success(array);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
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
    [WebAPI request:requestString
         parameters:nil
             Method:MPOST
          NeedToken:YES
            success:^(AFHTTPRequestOperation *operation) {
                success();
            } failure:^(AFHTTPRequestOperation *operation) {
                failure();
            }];
}

@end
