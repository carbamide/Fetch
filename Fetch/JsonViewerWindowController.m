//
//  JsonViewerWindowController.m
//  Fetch
//
//  Created by Josh on 9/13/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "JsonViewerWindowController.h"

@interface JsonViewerWindowController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation JsonViewerWindowController

- (id)initWithWindowNibName:(NSString *)nibOrNil json:(id)json
{
    self = [super initWithWindowNibName:nibOrNil];
    if (self) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            [self setJsonData:json];
        }
    }
    return self;
}

-(void)setJsonData:(id)jsonData
{
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        _jsonData = jsonData;
        
        [self setDataArray:@[jsonData]];
    }
    else {
        [self setDataArray:jsonData];
    }
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

#pragma mark
#pragma mark NSOutlineViewDataSource

- (BOOL)outlineView:(NSOutlineView *)oV isItemExpandable:(id)item
{
    if ([[self jsonData] hasKey:item]) {
        if ([[self jsonData][item] isKindOfClass:[NSDictionary class]]) {
            return YES;
        }
        else if ([[self jsonData][item] isKindOfClass:[NSArray class]]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

- (NSInteger)outlineView:(NSOutlineView *)oV numberOfChildrenOfItem:(id)item
{
    if (!item) {
        return [[self jsonData] count];
    }
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item allKeys] count];
    }
    else if ([[self jsonData][item] isKindOfClass:[NSArray class]]) {
        return 0;
    }
    else {
        return [[self jsonData][item] count];
    }
}

- (id)outlineView:(NSOutlineView *)oV child:(NSInteger)index ofItem:(id)item
{
    if ([[self jsonData] isKindOfClass:[NSDictionary class]]) {
        if (item == nil) {
            return [[[self jsonData] allKeys] objectAtIndex:index];
        }
        
        if ([item isKindOfClass:[NSDictionary class]]) {
            return [self jsonData][item];
        }
        else if ([[self jsonData][item] isKindOfClass:[NSArray class]]) {
            return nil;
        }
        else {
            return [[self jsonData][item] allKeys][index];
        }
    }
    
    return nil;
}

- (id)outlineView:(NSOutlineView *)oV objectValueForTableColumn:(NSTableColumn *)theColumn byItem:(id)item
{
    if ([[theColumn identifier] isEqualToString:@"Key"]) {
        return item;
    }
    else {
        if ([[self jsonData] hasKey:item]) {
            if ([[self jsonData][item] isKindOfClass:[NSDictionary class]]) {
                return nil;
            }
            else if ([[self jsonData][item] isKindOfClass:[NSArray class]]) {
                return nil;
            }
            else {
                return [self jsonData][item];
            }
        }
        else {            
            return [self jsonData][[oV parentForItem:item]][item];
        }
    }
    
    return nil;
}

@end
