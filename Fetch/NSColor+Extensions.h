//
//  NSColor+Extensions.h
//  Fetch for OSX
//
//  Created by Josh on 10/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Extensions)

/**
 * String representation of color
 * @return NSString representation of NSColor
 */
-(NSString *)stringRepresentation;

/**
 * NSData object of NSColor
 * @return NSData object that contains archived NSColor information
 */
-(NSData *)colorForRegisterDefaults;

@end
