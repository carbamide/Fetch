//
//  Urls.h
//  Fetch
//
//  Created by Josh on 9/8/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CustomPayload, Projects;

@interface Urls : NSManagedObject

@property (nonatomic, retain) NSNumber * method;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Projects *project;
@property (nonatomic, retain) CustomPayload *customPayload;

@end
