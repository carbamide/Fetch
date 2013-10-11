//
//  DataModeler.h
//  Fetch
//
//  Created by Josh on 9/15/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonHandler : NSObject

/**
 * Initialization
 * @return JsonHandler object
 */
-(id)init;

/**
 * Add entries to the JsonHandler
 * @param entries Entries to add to the handler
 */
-(void)addEntries:(id)entries;

/// Data source for JsonHandler
@property (strong, nonatomic) NSMutableArray *dataSource;

@end
