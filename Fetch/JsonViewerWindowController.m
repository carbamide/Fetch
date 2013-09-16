//
//  JsonViewerWindowController.m
//  Fetch
//
//  Created by Josh on 9/13/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "JsonViewerWindowController.h"
#import "JsonHandler.h"
#import "NodeObject.h"

@interface JsonViewerWindowController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation JsonViewerWindowController

- (id)initWithWindowNibName:(NSString *)nibOrNil json:(id)json
{
    self = [super initWithWindowNibName:nibOrNil];
    if (self) {
        [self setJsonData:json];
        
        JsonHandler *tempData = [[JsonHandler alloc] init];
        
        [tempData addEntries:json];
        
        [self setDataArray:[tempData dataSource]];
    }
    return self;
}

-(void)setJsonData:(id)jsonData
{
    _jsonData = jsonData;
    
    JsonHandler *tempData = [[JsonHandler alloc] init];
    
    [tempData addEntries:_jsonData];
    
    [self setDataArray:[tempData dataSource]];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

#pragma mark
#pragma mark NSOutlineViewDataSource

- (BOOL)outlineView:(NSOutlineView *)oV isItemExpandable:(id)item
{
    NodeObject *tempObject = item;
    
    NSLog(@"%lu", (unsigned long)[[tempObject children] count]);
    
    if ([[tempObject children] count] > 0) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)oV numberOfChildrenOfItem:(id)item
{
    NodeObject *tempObject = item;
    
    if (!tempObject) {
        return [[self dataArray] count];
    }
    else {
        if ([tempObject children]) {
            return [[tempObject children] count];
        }
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)oV child:(NSInteger)index ofItem:(id)item
{
    NodeObject *tempObject = item;

    if (!tempObject) {
        return [self dataArray][index];
    }
    else {
        return [tempObject children][index];
    }
    
    return nil;
}

- (id)outlineView:(NSOutlineView *)oV objectValueForTableColumn:(NSTableColumn *)theColumn byItem:(id)item
{
    NodeObject *tempObject = item;
    
    if ([[theColumn identifier] isEqualToString:@"Key"]) {
        return [tempObject nodeTitle];
    }
    else {
        return [tempObject nodeValue];
    }
    
    return nil;
}

@end
