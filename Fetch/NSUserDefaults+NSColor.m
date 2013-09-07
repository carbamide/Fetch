//
//  NSUserDefaults+NSColor.m
//  Fetch
//
//  Created by Josh on 9/7/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NSUserDefaults+NSColor.h"

@implementation NSUserDefaults (NSColor)

-(void)setColor:(NSColor *)color forKey:(NSString *)key
{
    NSData *colorData = [NSArchiver archivedDataWithRootObject:color];
    
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:key];
}

-(NSColor *)colorForKey:(NSString *)key
{
    NSColor *color = nil;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:key];
    
    if (data) {
        color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:data];
    }
    
    return color;
}

@end
