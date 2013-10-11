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

/**
 * This method is for saving an NSColor to NSUserDefaults.  It archives the NSColor as NSData and saves it
 *
 * @param color The NSColor to save
 * @param key The key to save the NSColor to
 */
-(void)setColor:(NSColor *)color forKey:(NSString *)key;

/**
 * The method returns an NSColor for a specified key
 *
 * @param key The key to look in for a color
 * @return NSColor object from specified key
 */
-(NSColor *)colorForKey:(NSString *)key;

@end
