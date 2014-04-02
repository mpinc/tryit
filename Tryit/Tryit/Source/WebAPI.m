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

+ (void) sendRequest:(NSMutableURLRequest *) request
           needToken:(BOOL) needToken
             success:(void (^)(AFHTTPRequestOperation *operation))success
             failure:(void (^)(AFHTTPRequestOperation *operation))failure
{
    if (needToken) {
        AppDelegate *appDelegate = [AppDelegate getAppdelegate];
        if ([appDelegate getAccessToken] == nil) {
            [UIFunction removeMaskView];
            return;
        }else {
            [request addValue:[appDelegate getAccessToken] forHTTPHeaderField:authToken];
        }
    }

    AFHTTPRequestOperationManager *manager = [WebAPI getManager];

    [request setTimeoutInterval:TIMEOUT];
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

+ (void) request:(NSString *) path
      parameters:(NSDictionary *)parameters
          Method:(NSString*) method
       NeedToken:(BOOL) needToken
         success:(void (^)(AFHTTPRequestOperation *operation))success
         failure:(void (^)(AFHTTPRequestOperation *operation))failure
{
    AFHTTPRequestOperationManager *manager = [WebAPI getManager];

    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:nil];

    [WebAPI sendRequest:request needToken:needToken success:success failure:failure];
}

+ (void) formRequest:(NSString *) path
          parameters:(NSDictionary *)parameters
           NeedToken:(BOOL) needToken
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
             success:(void (^)(AFHTTPRequestOperation *operation))success
             failure:(void (^)(AFHTTPRequestOperation *operation))failure
{
    AFHTTPRequestOperationManager *manager = [WebAPI getManager];

    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:MPOST URLString:[[NSURL URLWithString:path relativeToURL:manager.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];

    [WebAPI sendRequest:request needToken:needToken success:success failure:failure];
}

#pragma mark - API Functions

+ (void) loginWithUserName:(NSString *) userName Password:(NSString *) password success:(void (^)(id responseObject))success failure:(void (^)()) failure
{
    NSString *requestString = @"/cust/do/login";
    NSDictionary *dict = @{@"user":userName,@"password":password};
    [WebAPI request:requestString parameters:dict Method:MPOST NeedToken:NO
            success:^(AFHTTPRequestOperation *operation) {
                success(operation.responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
}

+ (void) signUpWithPassword:(NSString *) password email:(NSString *) email success:(void (^)(id responseObject))success failure:(void (^)()) failure
{
    NSString *requestString = @"/cust/";
    NSDictionary *dict = @{@"email":email, @"password":password, @"active":@"1"};
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
    NSString *requestString = [NSString stringWithFormat:@"biz/get/topDish"];
    NSDictionary *dict = @{@"size":[NSString stringWithFormat:@"%d",topx]};
    [WebAPI request:requestString parameters:dict Method:MGET NeedToken:NO
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
    NSString *requestString = @"/biz";
    NSDictionary *dict = @{@"latitude":[NSString stringWithFormat:@"%f",coordinate.latitude], @"longitude":[NSString stringWithFormat:@"%f",coordinate.longitude]};
    [WebAPI request:requestString parameters:dict Method:MGET NeedToken:NO
            success:^(AFHTTPRequestOperation *operation) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *restDict in operation.responseObject) {
                    RestaurantItem * item = [[RestaurantItem alloc] initWithDict:restDict];
                    [array addObject:item];
                }
                success(array);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
}

+ (void) getProductWithRestId:(NSString *) restId success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/biz/%@/prod", restId];

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

+ (void) getpromoWithProduct:(ProductItem*) item success:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/biz/%@/prod/%@/promo", item.biz_id, item.prod_id];

    [WebAPI request:requestString parameters:nil Method:MGET NeedToken:NO
            success:^(AFHTTPRequestOperation *operation) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *restDict in operation.responseObject) {
                    CouponItem *item = [[CouponItem alloc] initWithDict:restDict];
                    [array addObject:item];
                }
                success(array);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
}

+ (void) getRestaurantsSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    NSString *requestString = [NSString stringWithFormat:@"/cust/%@/biz",appDelegate.userId];

    [WebAPI request:requestString parameters:nil Method:MGET NeedToken:YES
            success:^(AFHTTPRequestOperation *operation) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *restDict in operation.responseObject) {
                    RestaurantItem *item = [[RestaurantItem alloc] initWithDict:restDict];
                    [array addObject:item];
                }
                success(array);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
}

+ (void) getUserPorfileSuccess:(void (^)(UserProfile *userProfile))success failure:(void (^)()) failure
{
    NSString *requestString = @"/customerInfo";
    [WebAPI request:requestString parameters:nil Method:MGET NeedToken:YES
            success:^(AFHTTPRequestOperation *operation) {
                UserProfile *userProfile = [[UserProfile alloc] initWithDict:operation.responseObject];
                success(userProfile);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
            }];
}

+ (void) getUserShareRestaurantID:(NSString*) bizId WithSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)()) failure
{
    AppDelegate *appDelegate = [AppDelegate getAppdelegate];
    NSString *requestString = [NSString stringWithFormat:@"/cust/from/%@/coupon?bizId=%@", appDelegate.userId, bizId];
    [WebAPI request:requestString parameters:nil Method:MGET NeedToken:YES
            success:^(AFHTTPRequestOperation *operation) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dict in operation.responseObject) {
                    ShareItem *item = [[ShareItem alloc] initWithDict:dict];
                    [array addObject:item];
                }
                success(array);
            }
            failure:^(AFHTTPRequestOperation *operation) {
                failure(operation);
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

+ (void) createCouponWithCCItem:(CreateCouponItem*) ccItem success:(void (^)())success failure:(void (^)()) failure
{
    NSString *requestString = [NSString stringWithFormat:@"/cust/%@/biz/%@/promo/%@/coupon", ccItem.userId, ccItem.bizId,ccItem.promotionId];
    NSDictionary *dict = @{@"personal_msg":ccItem.shareWord,@"to_email":ccItem.emailList};
    [WebAPI formRequest:requestString parameters:dict NeedToken:YES
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(ccItem.image, 0.5) name:@"image" fileName:@"coupon.png" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation) {
        success();
    } failure:^(AFHTTPRequestOperation *operation) {
        failure();
    }];
}

@end
