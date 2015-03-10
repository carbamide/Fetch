//
//  DataHandler.h
//  Fetch
//
//  Created by Josh on 9/8/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Foundation;

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

/**
 * Export project as plain text
 *
 * @param project The Project to export
 * @param url The url to save the Project to
 * @return NSString representation of the exported Project
 */
+(NSString *)exportProjectAsPlainText:(Projects *)project toUrl:(NSURL *)url;

/**
 * Helper method that converts the method type enum to a standard NSString
 *
 * @param method The int representation of the enum value
 * @return NSString representation of the method type enum value.
 */
+(NSString *)methodStringForMethodType:(int) method;

@end
