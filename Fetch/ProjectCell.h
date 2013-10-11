//
//  ProjectCell.h
//  Fetch
//
//  Created by Josh on 10/1/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Projects;

@interface ProjectCell : NSTableCellView

/// Button to add a url to the Projects object that the cell is showing
@property (strong, nonatomic) IBOutlet NSButton *addUrlButton;

/// Projects object that the cell is showing
@property (strong, nonatomic) Projects *project;

/**
 * Adds url to the project that the cell is displaying
 * @param sender The caller of this method
 */
-(IBAction)addUrl:(id)sender;

@end
