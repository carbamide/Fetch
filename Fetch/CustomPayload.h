//
//  CustomPayload.h
//  Fetch
//
//  Created by Josh on 9/8/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Urls;

@interface CustomPayload : NSManagedObject

@property (nonatomic, retain) NSString * payload;
@property (nonatomic, retain) Urls *url;

@end
