//
//  RestaurantItem.h
//  Tryit
//
//  Created by Mars on 2/26/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantItem : NSObject

@property (nonatomic, strong) NSString *biz_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phone_no;
@property (nonatomic, strong) NSURL *restaurantImageUrl;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

- (id) initWithDict:(NSDictionary *) dict;

@end
