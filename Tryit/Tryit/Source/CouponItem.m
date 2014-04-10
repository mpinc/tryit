//
//  CouponItem.m
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "CouponItem.h"
#import "NSString+Utlity.h"
static NSDateFormatter *dateFormatter = nil;

@implementation CouponItem

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if(self)
    {

        /*
         {
         "name": "10% off",
         "promotion_id": 100001,
         "biz_id": 100001,
         "prod_id": 100001,
         "description": "We offer 10% for regular coffee",
         "discount_pct": 10,
         "start_date": "2014-01-31T16:00:00.000Z",
         "end_date": null,
         "active": 1,
         "created_on": "2014-03-17T02:01:09.000Z",
         "updated_on": "2014-03-17T02:01:09.000Z"
         }
         */

        if(dateFormatter == nil)
        {
            // 2014-03-27T06:23:59.000Z
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        }
        
        self.biz_id = dict[@"biz_id"];
        self.prod_id = dict[@"prod_id"];
        self.promotion_id = dict[@"promotion_id"];
        self.name = dict[@"name"];
        self.couPonDescription = dict[@"description"];
        if (![NSString isEmptyString:dict[@"end_date"]]) {
            self.endDate = [dateFormatter dateFromString:dict[@"end_date"]];
        }
    }
    return self;
}

@end
