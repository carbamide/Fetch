//
//  Projects.h
//  Fetch for OSX
//
//  Created by Josh on 10/4/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Urls;

@interface Projects : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * expanded;
@property (nonatomic, retain) NSSet *urls;
@end

@interface Projects (CoreDataGeneratedAccessors)

- (void)addUrlsObject:(Urls *)value;
- (void)removeUrlsObject:(Urls *)value;
- (void)addUrls:(NSSet *)values;
- (void)removeUrls:(NSSet *)values;

@end
