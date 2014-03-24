//
//  NSString+Utlity.h
//  
//
//  Created by Mars on 13-5-9.
//  Copyright (c) 2013年 SKTLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@interface NSString (Utlity)

+ (BOOL) isEmptyString:(NSString *)string;
+ (BOOL) isEmptyString:(NSString *)string WithPromptString:(NSString*) promptString;

+ (BOOL) isValidateNumber:(NSString *) name;
+ (BOOL) isValidateChar:(NSString *) text;
+ (BOOL) isValidatePhone:(NSString*) phoneNumber;
+ (BOOL) isValidateMail:(NSString*) email;

+ (BOOL) stringContainsEmoji:(NSString *)string;

+ (NSString *)urlEncodeValue:(NSString *)str;

- (void) callPhoneNumber;

+ (NSString *) turnToStringWithObejct:(id) object;

- (id)MD5;
@end
