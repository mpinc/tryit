//
//  ShareItem.m
//  Tryit
//
//  Created by Mars on 3/19/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "ShareItem.h"

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

@end
