//
//  NSHTTPURLResponse+Extensions.m
//  Fetch for OSX
//
//  Created by Josh on 10/28/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NSHTTPURLResponse+Extensions.h"

@implementation NSHTTPURLResponse (Extensions)

-(BOOL)isGoodResponse
{
    if (NSLocationInRange([self statusCode], NSMakeRange(200, (299 - 200)))) {
        return YES;
    }
    
    return NO;
}

-(NSString *)responseString
{
    return [self statusCode] ? [NSString stringWithFormat:@"Response - %li\n", [self statusCode]] : nil;
}

@end
