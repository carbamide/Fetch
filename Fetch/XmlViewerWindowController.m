//
//  XmlViewerWindowController.m
//  Fetch for OSX
//
//  Created by Joshua Barrow on 11/12/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "XmlViewerWindowController.h"
#import "NodeObject.h"
#import "JsonHandler.h"

@interface XmlViewerWindowController ()
/**
 *  Data source
 */
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation XmlViewerWindowController

- (id)initWithWindowNibName:(NSString *)nibOrNil xml:(id)xml
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    self = [super initWithWindowNibName:nibOrNil];
    if (self) {
        
        if ([xml isKindOfClass:[NSArray class]]) {
            xml = @{@"Root": xml};
        }
        
        JsonHandler *tempData = [[JsonHandler alloc] init];
        [tempData addEntries:xml];
        
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
    
    JsonHandler *tempData = [[JsonHandler alloc] init];
    
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
    
    NodeObject *tempObject = item;
    
    if ([[tempObject children] count] > 0) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)oV numberOfChildrenOfItem:(id)item
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
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
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
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
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
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
