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

-(void)setXmlData:(id)xmlData
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    if ([xmlData isKindOfClass:[NSArray class]]) {
        xmlData = @{@"Root": xmlData};
    }
    
    JsonHandler *tempData = [[JsonHandler alloc] init];
    
    [tempData addEntries:xmlData];
    
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
            if ([[tempObject nodeValue] isKindOfClass:[NSDictionary class]]) {
                return @"<no value>";
            }
            else {
                return [tempObject nodeValue];
            }
        }
    }
    
    return nil;
}

@end
