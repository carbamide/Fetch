//
//  CsvViewerWindowController.h
//  Fetch for OSX
//
//  Created by Josh on 10/21/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Cocoa;

@interface CsvViewerWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

/// NSArray holding CSV data source
@property (strong, nonatomic) NSArray *dataSource;

/// NSTableView to display parsed CSV
@property (strong, nonatomic) IBOutlet NSTableView *csvTableView;

/// Label to hold number of rows in table
@property (strong) IBOutlet NSTextField *rowCountLabel;

///Number of CSV columns
@property (nonatomic) NSInteger numberOfColumns;

/*
 * @param windowNibName Name, as a string, of the nib to load
 * @param owner Caller of this window controller
 * @param dataSource Data source for the table, as an NSArray
 * @return self instance of this window controller
 */
- (id)initWithWindowNibName:(NSString *)windowNibName dataSource:(NSArray *)dataSource;

@end
