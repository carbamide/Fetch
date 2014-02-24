//
//  NSHTTPURLResponse+Extensions.h
//  Fetch for OSX
//
//  Created by Josh on 10/28/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Foundation;

@interface NSHTTPURLResponse (Extensions)

-(BOOL)isGoodResponse;
-(NSString *)responseString;

@end
