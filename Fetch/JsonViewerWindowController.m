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
        [self setJsonData:json];
    }
    return self;
}

-(void)setJsonData:(id)jsonData
{
    _jsonData = jsonData;
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
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
    if ([oV parentForItem:item]) {
        if ([item isEqualToString:@"Dictionary"] || [item isEqualToString:@"Array"]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    
    if ([[self jsonData] isKindOfClass:[NSDictionary class]]) {
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
    }
    else {
        return YES;
    }
    
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)oV numberOfChildrenOfItem:(id)item
{
    if ([[self jsonData] isKindOfClass:[NSDictionary class]]) {
        if (!item) {
            return [[self jsonData] count];
        }
        
        if ([oV parentForItem:item]) {
            return [[[self jsonData][[oV parentForItem:item]][0] allKeys] count];
        }
        
        if ([item isKindOfClass:[NSDictionary class]]) {
            return [[item allKeys] count];
        }
        else if ([[self jsonData][item] isKindOfClass:[NSArray class]]) {
            return [[self jsonData][item] count];
        }
        else {
            return [[self jsonData][item] count];
        }
    }
    else {
        if (!item) {
            return [[self jsonData] count];
        }
        else {
            NSDictionary *tempDict = [self jsonData][[oV rowForItem:item]];
            
            return [[tempDict allKeys] count];
        }
    }
}

- (id)outlineView:(NSOutlineView *)oV child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        if ([[self jsonData] isKindOfClass:[NSDictionary class]]) {
            return [[[self jsonData] allKeys] objectAtIndex:index];
        }
        else {
            return @"Array";
        }
    }
    
    if ([oV parentForItem:item]) {
        return [[self jsonData][[oV parentForItem:item]][0] allKeys][index];
    }
    
    if ([[self jsonData] isKindOfClass:[NSDictionary class]]) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            return [self jsonData][item];
        }
        else if ([[self jsonData][item] isKindOfClass:[NSArray class]]) {
            return @"Dictionary";
        }
        else {
            return [[self jsonData][item] allKeys][index];
        }
    }
    else {
        if ([[[self jsonData] objectAtIndex:index] isKindOfClass:[NSDictionary class]]) {            
            return @"Dictionary";
        }
        else if ([[[self jsonData] objectAtIndex:index] isKindOfClass:[NSArray class]]) {
            return @"Array";
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
        if ([[self jsonData] isKindOfClass:[NSDictionary class]]) {
            if ([oV parentForItem:item]) {
                NSString *parentForItem = [oV parentForItem:item];
                NSString *grandParentForItem = [oV parentForItem:parentForItem];
                
                NSArray *tempArray = [self jsonData][grandParentForItem];
                
                NSString *tempString = tempArray[0][item];
                
                return tempString;
            }
            
            if ([[self jsonData] hasKey:item]) {
                if ([[self jsonData][item] isKindOfClass:[NSDictionary class]]) {
                    return @"Dictionary";
                }
                else if ([[self jsonData][item] isKindOfClass:[NSArray class]]) {
                    return @"Array";
                }
                else {
                    return [self jsonData][item];
                }
            }
        }
        else {
            return nil;
        }

    }
    
    return nil;
}

@end
