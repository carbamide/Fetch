//
//  NSString+Extensions.m
//  Fetch for OSX
//
//  Created by Josh on 10/4/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+(NSString *)blankString
{
    return @"";
}

-(BOOL)hasValidURLPrefix
{
    BOOL validPrefix = NO;
    
    NSArray *validUrlPrefixes = @[@"http", @"https"];
    
    for (NSString *prefix in validUrlPrefixes) {
        if ([self hasPrefix:prefix]) {
            validPrefix = YES;
        }
    }
    
    return validPrefix;
}

-(BOOL)hasValue
{
    return self && [self length] > 0;
}

-(NSString *)formatInterval:(NSTimeInterval)interval
{
    unsigned long milliseconds = interval;
    unsigned long seconds = milliseconds / 1000;
    
    milliseconds %= 1000;
    
    unsigned long minutes = seconds / 60;
    
    seconds %= 60;
    
    unsigned long hours = minutes / 60;
    
    minutes %= 60;
    
    NSMutableString * result = [NSMutableString new];
    
    [result appendString:@"Elapsed Time: "];
    
    if (hours != 0) {
        [result appendFormat: @"%lu %@, ", hours, hours == 1 ? @"hour" : @"hours"];
    }
    
    if (minutes != 0) {
        [result appendFormat: @"%2lu %@, ", minutes, minutes == 1 ? @"minute" : @"minutes"];
    }
    
    if (seconds != 0) {
        [result appendFormat: @"%2lu %@ and ", seconds, seconds == 1 ? @"second" : @"seconds"];
    }
    
    [result appendFormat: @"%2lu %@", milliseconds, milliseconds == 1 ? @"millisecond" : @"milliseconds"];
    
    return result;
}

@end
