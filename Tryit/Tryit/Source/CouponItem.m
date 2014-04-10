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
