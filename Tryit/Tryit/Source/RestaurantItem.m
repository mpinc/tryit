//
//  RestaurantItem.m
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "RestaurantItem.h"

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
        }

        self.latitude = [dict[@"latitude"] floatValue];
        self.longitude = [dict[@"longitude"] floatValue];
    }
    return self;
}

@end
