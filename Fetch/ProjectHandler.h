//
//  DataHandler.h
//  Fetch
//
//  Created by Josh on 9/8/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Projects;

@interface ProjectHandler : NSObject

/**
 * Import Project from Path
 *
 * @param path The path to load the project from
 * @return Success or failure boolean
 */
+(BOOL)importFromPath:(NSString *)path;

/**
 * Export project
 *
 * @param project The Project to export
 * @param url The url to save the Project to
 * @return NSDictionary representation of the exported Project
 */
+(NSDictionary *)exportProject:(Projects *)project toUrl:(NSURL *)url;

@end
