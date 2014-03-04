//
//  TIContact.h
//  Tryit
//
//  Created by Mars on 3/4/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ABContactsHelper.h"

@interface TIContact : NSObject

@property (strong, nonatomic) ABContact *contact;
@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) NSInteger sectionNumber;

- (id) initWithContact:(ABContact*) abContact;

@end
