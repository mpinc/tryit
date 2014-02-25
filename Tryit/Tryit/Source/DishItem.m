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
        self.headImageUrl = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.gif" ];
        self.dishImageUrl = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D2048/sign=7586b08a2d2eb938ec6d7df2e15a8435/b2de9c82d158ccbf4de006511bd8bc3eb1354178.jpg" ];
    }
    return self;
}

@end
