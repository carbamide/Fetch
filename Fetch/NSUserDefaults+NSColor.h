//
//  NSUserDefaults+NSColor.h
//  Fetch
//
//  Created by Josh on 9/7/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Foundation;
@import AppKit;

@interface NSUserDefaults (NSColor)

-(void)setColor:(NSColor *)color forKey:(NSString *)key;

-(NSColor *)colorForKey:(NSString *)key;

@end
