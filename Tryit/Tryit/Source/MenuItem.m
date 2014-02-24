//
//  MenuItem.m
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (id) initWithName:(NSString *) name Image:(NSString *) imageName
{
    self = [super init];
    if (self) {
        self.menuName = name;

        self.menuImage = [UIImage imageNamed:imageName];
    }
    return self;
}

@end
