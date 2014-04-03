//
//  MenuItem.h
//  Tryit
//
//  Created by Mars on 2/24/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, strong) UIImage *menuImage;
@property (nonatomic, strong) UINavigationController *viewController;
- (id) initWithName:(NSString *) name Image:(NSString *) imageName;

@end
