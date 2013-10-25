//
//  CsvViewerWindowController.m
//  Fetch for OSX
//
//  Created by Josh on 10/21/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "CsvViewerWindowController.h"

@interface CsvViewerWindowController ()
@end

@implementation CsvViewerWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName dataSource:(NSArray *)dataSource
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

- (void)windowDidLoad
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [super windowDidLoad];
    
    [[self rowCountLabel] setStringValue:[NSString stringWithFormat:@"%ld Rows", (long)[[self csvTableView] numberOfRows]]];
    
    NSTableColumn *column[[[self dataSource][0] count]];
    
    for (int i = 0; i < [[self dataSource][0] count]; i++){
        column[i] = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%i", i]];
        [column[i] setWidth:100];
        [[column[i] headerCell] setStringValue:[self dataSource][0][i]];
        [[self csvTableView] addTableColumn:column[i]];
    }
    
    [self setNumberOfColumns:[[self dataSource][0] count]];
    
    NSMutableArray *dataSourceMutableCopy = [[self dataSource] mutableCopy];
    
    [dataSourceMutableCopy removeObjectAtIndex:0];
    
    [self setDataSource:dataSourceMutableCopy];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    return [[self dataSource] count] - 2;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    NSArray *tempArray = [self dataSource][rowIndex];
    
    for (int columnIndex = 0; columnIndex < [self numberOfColumns]; columnIndex++) {
        if ([[NSString stringWithFormat:@"%i", columnIndex] isEqualToString:[aTableColumn identifier]]) {
            return tempArray[columnIndex];
        }
    }
    
    return nil;
}

@end
