//
//  Parameters.h
//  Fetch
//
//  Created by Josh on 9/9/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Urls;

@interface Parameters : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Urls *url;

@end
