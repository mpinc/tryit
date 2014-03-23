//
//  DishItem.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "DishItem.h"

@implementation DishItem

- (id) initWithEx
{
    self = [super init];
    if (self) {
        self.userName = @"Tom";
        self.dishImageUrl = [NSURL URLWithString:@"http://img2.ph.126.net/q01iRkaDBUfPyIaMzgYd2Q==/2576340461849975894.jpg" ];
    }
    return self;
}

@end
