//
//  NSString+Extensions.h
//  Fetch for OSX
//
//  Created by Josh on 10/4/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

/** 
 * Check if NSString has valid http or https URL prefix
 * @return Boolean of whether or not NSString has valid URL prefix
 */
-(BOOL)hasValidURLPrefix;

/**
 * Check whether NSString has value
 * @return Whether or not NSString has value
 */
-(BOOL)hasValue;
/**
 * Converts NSTimeInterval to friendly string
 * @param interval The NSTimeInterval to convert
 * @return Friendly NSString of the interval
 */
-(NSString *)formatInterval:(NSTimeInterval)interval;

@end
