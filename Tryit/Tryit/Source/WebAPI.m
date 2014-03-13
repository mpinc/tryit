//
//  WebAPI.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "WebAPI.h"
#import "RestaurantItem.h"

#define BaseURL @"http://127.0.0.1:8080"

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

+ (void) getNearRestaurantWithCoordinate:(CLLocationCoordinate2D) coordinate
{
    [[WebAPI getManager] GET:@"/biz" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *restDict in responseObject) {
            RestaurantItem * item = [[RestaurantItem alloc] initWithDict:restDict];
            [array addObject:item];
        }
        NSLog(@"array:%@", array);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error); 
    }];
}

@end
