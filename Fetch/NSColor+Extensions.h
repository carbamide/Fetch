//
//  NSColor+Extensions.h
//  Fetch for OSX
//
//  Created by Josh on 10/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Cocoa;

@interface NSColor (Extensions)

/**
 * NSData object of NSColor
 * @return NSData object that contains archived NSColor information
 */
-(NSData *)colorForRegisterDefaults;

@end
