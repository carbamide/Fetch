//
//  NSColor+Extensions.m
//  Fetch for OSX
//
//  Created by Josh on 10/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NSColor+Extensions.h"

@implementation NSColor (Extensions)

- (NSString *)stringRepresentation
{
    NSColor	*color = self;
    
    if([color colorSpaceName] != NSCalibratedRGBColorSpace) {
        NSLog(@"%s must convert colour from %@", __PRETTY_FUNCTION__, [color colorSpaceName]);
        
        if((color = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace]) == nil) {
            [NSException raise:NSInvalidArgumentException format:@"Cannot convert colour to RGB colour space."];
        }
    }
    
    return [NSString stringWithFormat:@"%g %g %g %g", [color redComponent], [color greenComponent], [color blueComponent], [color alphaComponent]];
}

-(NSData *)colorForRegisterDefaults
{
    return [NSArchiver archivedDataWithRootObject:self];
}

@end
