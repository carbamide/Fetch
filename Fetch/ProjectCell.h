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

@property (strong, nonatomic) IBOutlet NSButton *addUrlButton;
@property (strong, nonatomic) Projects *project;

-(IBAction)addUrl:(id)sender;

@end
