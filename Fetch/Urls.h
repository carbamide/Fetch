//
//  Url.h
//  Fetch
//
//  Created by Josh on 9/7/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Projects;

@interface Urls : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Projects *project;

@end
