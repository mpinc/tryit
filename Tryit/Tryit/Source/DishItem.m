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
        self.dishImageUrl = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.gif" ];
    }
    return self;
}

@end
