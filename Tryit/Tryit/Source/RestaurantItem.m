//
//  RestaurantItem.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "RestaurantItem.h"
#import "ShareItem.h"
#import "NSString+Utlity.h"
#import "WebAPI.h"
@implementation RestaurantItem

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if(self)
    {
        self.biz_id = [NSString ToString:dict[@"biz_id"]];
        self.name = [NSString ToString:dict[@"name"]];
        self.address = [NSString ToString:dict[@"address"]];
        self.phone_no = [NSString ToString:dict[@"phone_no"]];

        if (dict[@"img_url"] != nil) {

            self.restaurantImageUrl = [WebAPI getImageURL:dict[@"img_url"]];
        }

        self.latitude = [dict[@"latitude"] floatValue];
        self.longitude = [dict[@"longitude"] floatValue];

        self.point = [dict[@"total_points_earned"] stringValue];
        self.distance = [dict[@"distance"] floatValue];

        self.couponArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

@end
