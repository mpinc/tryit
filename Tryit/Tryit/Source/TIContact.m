//
//  TIContact.m
//  Tryit
//
//  Created by Mars on 3/4/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "TIContact.h"

@implementation TIContact

- (id) initWithContact:(ABContact*) abContact
{
    self = [super init];
    if (self) {
        self.contact = abContact;
        self.isSelected = NO;
        self.sectionNumber = 0;
        self.contactName = abContact.contactName;
        self.email = abContact.emailArray[0];
        self.image = abContact.image;
    }
    return self;
}

@end
