//
//  PlistViewerWindowController.m
//  Fetch for OSX
//
//  Created by Joshua Barrow on 11/15/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PlistViewerWindowController.h"
#import "NodeObject.h"
#import "DataHandler.h"

@interface PlistViewerWindowController ()
/**
 *  Data source
 */
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation PlistViewerWindowController

- (id)initWithWindowNibName:(NSString *)nibOrNil plist:(id)plist
{
    NSLog(@"%s", __FUNCTION__);
    
    self = [super initWithWindowNibName:nibOrNil];
    if (self) {
        
        if ([plist isKindOfClass:[NSArray class]]) {
            plist = @{@"Root": plist};
        }
        
        DataHandler *tempData = [[DataHandler alloc] init];
        [tempData addEntries:plist];
        
        [self setDataArray:[tempData dataSource]];
    }
    return self;
}

-(void)setPlistData:(id)plistData
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([plistData isKindOfClass:[NSArray class]]) {
        plistData = @{@"Root": plistData};
    }
    
    DataHandler *tempData = [[DataHandler alloc] init];
    
    [tempData addEntries:plistData];
    
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
    NSLog(@"%s", __FUNCTION__);
    
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
    NSLog(@"%s", __FUNCTION__);
    
    id tempObject = item;
    
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
    NSLog(@"%s", __FUNCTION__);
    
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
    NSLog(@"%s", __FUNCTION__);
    
    id tempObject = item;
    
    if ([[theColumn identifier] isEqualToString:@"Key"]) {
        if ([tempObject isKindOfClass:[NSArray class]]) {
            return [NSString stringWithFormat:@"Dictionary - %lu %@", [tempObject count], [tempObject count] == 1 ? @"element" : @"elements"];
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