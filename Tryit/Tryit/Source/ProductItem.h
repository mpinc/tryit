//
//  ProductItem.h
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponItem.h"

@interface ProductItem : NSObject

@property (nonatomic, strong) NSString *biz_id;
@property (nonatomic, strong) NSString *prod_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *bizName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSURL *img_url;
@property (nonatomic, strong) NSString *promotion_id;
@property (nonatomic, strong) NSString *promotionName;
@property (nonatomic, strong) NSMutableArray *couponArray;
@property (nonatomic, strong) CouponItem *selectCoupon;

- (id) initWithDict:(NSDictionary *) dict;

@end
