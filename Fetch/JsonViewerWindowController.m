//
//  JsonViewerWindowController.m
//  Fetch
//
//  Created by Josh on 9/13/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "JsonViewerWindowController.h"
#import "DataHandler.h"
#import "NodeObject.h"

@interface JsonViewerWindowController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation JsonViewerWindowController

- (id)initWithWindowNibName:(NSString *)nibOrNil json:(id)json
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    self = [super initWithWindowNibName:nibOrNil];
    if (self) {
        
        if ([json isKindOfClass:[NSArray class]]) {
            json = @{@"Root": json};
        }
        
        DataHandler *tempData = [[DataHandler alloc] init];
        
        [tempData addEntries:json];
        
        [self setDataArray:[tempData dataSource]];
    }
    return self;
}

-(void)setJsonData:(id)jsonData
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    if ([jsonData isKindOfClass:[NSArray class]]) {
        jsonData = @{@"Root": jsonData};
    }
    
    DataHandler *tempData = [[DataHandler alloc] init];
    
    [tempData addEntries:jsonData];
    
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
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    id tempObject = item;
    
    if ([tempObject isKindOfClass:[NSArray class]]) {
        if ([tempObject count] > 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        if ([[tempObject children] count] > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)oV numberOfChildrenOfItem:(id)item
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    id tempObject = item;
    
    NSLog(@"%lu", (unsigned long)[[self dataArray] count]);
    NSLog(@"%lu", (unsigned long)[[[self dataArray][0] children] count]);
    
    if (!tempObject) {
        return [[self dataArray] count];
    }
    else {
        if ([tempObject isKindOfClass:[NSArray class]]) {
            return [tempObject count];
        }
        else {
            return [[tempObject children] count];
        }
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)oV child:(NSInteger)index ofItem:(id)item
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    id tempObject = item;
    
    if (!tempObject) {
        return [self dataArray][index];
    }
    else {
        if ([tempObject isKindOfClass:[NSArray class]]) {
            return tempObject[index];
        }
        return [tempObject children][index];
    }
    
    return nil;
}

- (id)outlineView:(NSOutlineView *)oV objectValueForTableColumn:(NSTableColumn *)theColumn byItem:(id)item
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    id tempObject = item;
    
    if ([[theColumn identifier] isEqualToString:@"Key"]) {
        if ([tempObject isKindOfClass:[NSArray class]]) {
            return [NSString stringWithFormat:@"Dictionary - %lu elements", [tempObject count]];
        }
        else {
            return [tempObject nodeTitle];
        }
    }
    else {
        if ([tempObject isKindOfClass:[NSArray class]]) {
            return [NSString string];
        }
        else {
            return [tempObject nodeValue];
        }
    }
    
    return nil;
}

@end
