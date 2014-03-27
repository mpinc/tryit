//
//  ProductItem.m
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProductItem.h"
#import "NSString+Utlity.h"
@implementation ProductItem

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if(self)
    {
        self.biz_id = [NSString ToString:dict[@"biz_id"]];
        self.prod_id = [NSString ToString:dict[@"prod_id"]];
        self.name = [NSString ToString:dict[@"productName"]];
        self.price = [NSString ToString:dict[@"price"]];
        self.bizName = [NSString ToString:dict[@"bizName"]];
        self.type = [NSString ToString:dict[@"type"]];
        self.description = [NSString ToString:dict[@"description"]];
        self.promotion_id = [NSString ToString:dict[@"promotion_id"]];

        if (dict[@"img_url"] != nil && ![dict[@"img_url"] isKindOfClass:[NSNull class]]) {
            self.img_url = [NSURL URLWithString:dict[@"img_url"]];
        }
    }
    return self;

}

@end
