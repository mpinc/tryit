//
//  RestaurantItem.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "RestaurantItem.h"
#import "ShareItem.h"
@implementation RestaurantItem

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if(self)
    {
        self.biz_id = dict[@"biz_id"];
        self.name = dict[@"name"];
        self.address = dict[@"address"];
        self.phone_no = dict[@"phone_no"];

        if (dict[@"restaurantImageUrl"] != nil) {
            self.restaurantImageUrl = [NSURL URLWithString:dict[@"restaurantImageUrl"]];
        }else {
            self.restaurantImageUrl = [NSURL URLWithString:@"http://travel.tw.tranews.com/hotel/nantou/jihyuehtan/images/2.jpg"];
        }

        self.latitude = [dict[@"latitude"] floatValue];
        self.longitude = [dict[@"longitude"] floatValue];

        self.point = [dict[@"total_points_earned"] stringValue];
        self.distance = [dict[@"distance"] floatValue];

        self.couponArray = @[[[ShareItem alloc]initWithEx], [[ShareItem alloc]initWithEx], [[ShareItem alloc]initWithEx], [[ShareItem alloc]initWithEx]];
    }
    return self;
}

@end
