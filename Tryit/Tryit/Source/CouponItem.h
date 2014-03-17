//
//  CouponItem.h
//  Tryit
//
//  Created by Mars on 3/17/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponItem : NSObject

@property (strong, nonatomic) NSString *promotion_id;
@property (strong, nonatomic) NSString *biz_id;
@property (strong, nonatomic) NSString *prod_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *couPonDescription;

- (id) initWithDict:(NSDictionary *) dict;

@end
