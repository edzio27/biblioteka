//
//  NSString+URLEncoding.m
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 08.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

+ (NSString*)encodeURL:(NSString *)string {
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}

@end
