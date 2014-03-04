//
//  DishItem.h
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishItem : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSURL *headImageUrl;
@property (nonatomic, strong) NSURL *dishImageUrl;

- (id) initWithEx;

@end