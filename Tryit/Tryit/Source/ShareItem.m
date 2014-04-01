//
//  ShareItem.m
//  Tryit
//
//  Created by Mars on 3/19/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//
#import "NSString+Utlity.h"
#import "ShareItem.h"

static NSDateFormatter *dateFormatter = nil;

@implementation ShareItem

- (id) initWithEx
{
    self = [super init];
    if(self != Nil)
    {
       /* @property (strong, nonatomic) NSURL *couponPhotoURL;
        @property (strong, nonatomic) NSDate *createDate;
        @property (strong, nonatomic) NSString *productName;
        @property (strong, nonatomic) NSString *productType;
        @property (strong, nonatomic) NSString *couponName;
        @property (strong, nonatomic) NSString *shareWords;
        @property (strong, nonatomic) NSArray *shareList; */

        self.couponPhotoURL = [NSURL URLWithString:@"http://pic.159.com/desk/user/2012/5/28/Jiker201241131139937.jpg"];
        self.createDate = [NSDate date];
        self.productName = @"Braised meatballs";
        self.productType = @"Chinese Food";
        self.couponName = @"10% Off";
        self.shareWords = @"Amazing food, you should not miss!";
        self.shareList = @[@"test_one@test.com", @"test_one@test.com", @"test_one@test.com", @"test_one@test.com", @"test_one@test.com",];
    }
    return self;
}

- (id) initWithDict:(NSDictionary*) dict
{
    self = [super init];
    if(self != Nil)
    {
        if(dateFormatter == nil)
        {
            // 2014-03-27T06:23:59.000Z
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        }
        if (![NSString isEmptyString:dict[@"img_url"]]) {
            self.couponPhotoURL = [NSURL URLWithString:dict[@"img_url"]];
        }
        self.createDate = [dateFormatter dateFromString:dict[@"created_on"]];
        self.productName = dict[@"prod_name"];
        self.couponName = dict[@"prod_name"];
        self.shareWords = dict[@"personal_msg"];
        self.shareList = @[dict[@"to_email"]];
    }
    return self;
}

@end
