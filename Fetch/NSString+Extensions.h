//
//  NSString+Extensions.h
//  Fetch for OSX
//
//  Created by Josh on 10/4/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

+(NSString *)blankString;
-(BOOL)hasValidURLPrefix;
-(BOOL)hasValue;

@end
