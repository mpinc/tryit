//
//  NSString+Utlity.m
//
//
//  Created by Mars on 13-5-9.
//  Copyright (c) 2013年 SKTLab. All rights reserved.
//

#import "NSString+Utlity.h"
#import "UIFunction.h"
@implementation NSString (Utlity)

+ (BOOL) isEmptyString:(NSString *)string
{
    return (string == nil || [string isEqualToString:@""]);
}

+ (BOOL) isEmptyString:(NSString *)string WithPromptString:(NSString*) promptString
{
    BOOL returnValue = [NSString isEmptyString:string];
    if (returnValue)
    {
        [UIFunction showAlertWithMessage:promptString];
    }
    return returnValue;
}

+ (BOOL) isValidateNumber:(NSString *) name
{
    NSString *numberRegex = @"[0-9 +]+";
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    BOOL isValidate = [predicateTest evaluateWithObject:name];
    return isValidate;
}

+ (BOOL) isValidateChar:(NSString *) text
{
    NSString *numberRegex = @"[a-zA-Z0-9~!@#$%^&*()_+ '.,<>?-]+";
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    BOOL isValidate = [predicateTest evaluateWithObject:text];
    return isValidate;
}

+ (BOOL) isValidateText:(NSString *) text
{
    NSString *numberRegex = @"[a-zA-Z0-9]+";
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    BOOL isValidate = [predicateTest evaluateWithObject:text];
    return isValidate;
}

+ (BOOL) isValidatePhone:(NSString*) phoneNumber
{
    NSString *numberRegex = @"[0-9]+";
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    BOOL isValidate = [predicateTest evaluateWithObject:phoneNumber];
    return isValidate;
}

+ (BOOL) isValidateMail:(NSString*) email
{
    NSString *numberRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    BOOL isValidate = [predicateTest evaluateWithObject:email];
    return isValidate;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {

         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     returnValue = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3)
             {
                 returnValue = YES;
             }

         }
         else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];

    return returnValue;
}

+ (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, NULL, kCFStringEncodingUTF8));
    return result;
}

- (void) callPhoneNumber
{
    NSString *phoneNumber = self;
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phoneNumber];
    NSString *trimTelUrl = [telUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:trimTelUrl];
    [[UIApplication sharedApplication] openURL:url];
}

+ (NSString *) turnToStringWithObejct:(id) object
{
    NSString *turnString = nil;
    if ([object respondsToSelector:@selector(stringValue)])
    {
        turnString = [object stringValue];
    }else {
        turnString = object;
    }
    return turnString;
}

- (id)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}

@end
