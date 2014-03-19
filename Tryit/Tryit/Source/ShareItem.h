//
//  ShareItem.h
//  Tryit
//
//  Created by Mars on 3/19/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareItem : NSObject

// coupon photo, date, product name, type, coupon name, sharewords and share to who(list their email address).
@property (strong, nonatomic) NSURL *couponPhotoURL;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSString *couponName;
@property (strong, nonatomic) NSString *shareWords;
@property (strong, nonatomic) NSArray *shareList;

- (id) initWithEx;

@end
