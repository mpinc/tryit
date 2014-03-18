//
//  ProductItem.m
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ProductItem.h"

@implementation ProductItem

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if(self)
    {
        self.biz_id = dict[@"biz_id"];
        self.prod_id = dict[@"prod_id"];
        self.name = dict[@"name"];
        self.price = dict[@"price"];
        self.dishDescription = dict[@"dishDescription"];

        if (dict[@"img_url"] != nil && ![dict[@"img_url"] isKindOfClass:[NSNull class]]) {
            self.img_url = [NSURL URLWithString:dict[@"img_url"]];
        }

        self.conpous = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;

}

@end