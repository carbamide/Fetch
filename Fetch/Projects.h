//
//  Projects.h
//  Fetch
//
//  Created by Josh on 9/7/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Headers, Parameters, Urls;

@interface Projects : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *headers;
@property (nonatomic, retain) NSSet *parameters;
@property (nonatomic, retain) NSSet *urls;
@end

@interface Projects (CoreDataGeneratedAccessors)

- (void)addHeadersObject:(Headers *)value;
- (void)removeHeadersObject:(Headers *)value;
- (void)addHeaders:(NSSet *)values;
- (void)removeHeaders:(NSSet *)values;

- (void)addParametersObject:(Parameters *)value;
- (void)removeParametersObject:(Parameters *)value;
- (void)addParameters:(NSSet *)values;
- (void)removeParameters:(NSSet *)values;

- (void)addUrlsObject:(Urls *)value;
- (void)removeUrlsObject:(Urls *)value;
- (void)addUrls:(NSSet *)values;
- (void)removeUrls:(NSSet *)values;

@end
