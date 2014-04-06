//
//  CreateCouponItem.h
//  Tryit
//
//  Created by Mars on 3/31/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateCouponItem : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *bizId;
@property (nonatomic, strong) NSString *promotionId;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *shareWord;
@property (nonatomic, strong) NSString *emailList;
@property (nonatomic, strong) NSString *couponName;
@property (nonatomic, strong) NSString *productName;

@end
