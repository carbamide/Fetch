//
//  Urls.h
//  Fetch
//
//  Created by Josh on 9/9/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Foundation;
#import <CoreData/CoreData.h>

@class Headers, Parameters, Projects;

@interface Urls : NSManagedObject

@property (nonatomic, retain) NSNumber * method;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * customPayload;
@property (nonatomic, retain) NSString * urlDescription;
@property (nonatomic, retain) Projects *project;
@property (nonatomic, retain) NSSet *parameters;
@property (nonatomic, retain) NSSet *headers;
@property (nonatomic, retain) NSString *siteStatus;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@end

@interface Urls (CoreDataGeneratedAccessors)

- (void)addParametersObject:(Parameters *)value;
- (void)removeParametersObject:(Parameters *)value;
- (void)addParameters:(NSSet *)values;
- (void)removeParameters:(NSSet *)values;

- (void)addHeadersObject:(Headers *)value;
- (void)removeHeadersObject:(Headers *)value;
- (void)addHeaders:(NSSet *)values;
- (void)removeHeaders:(NSSet *)values;

@end
