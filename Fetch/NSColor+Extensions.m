//
//  NSColor+Extensions.m
//  Fetch for OSX
//
//  Created by Josh on 10/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NSColor+Extensions.h"

@implementation NSColor (Extensions)

-(NSData *)colorForRegisterDefaults
{
    return [NSArchiver archivedDataWithRootObject:self];
}

@end
