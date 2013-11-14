//
//  XmlViewerWindowController.h
//  Fetch for OSX
//
//  Created by Joshua Barrow on 11/12/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  XML Viewer
 */
@interface XmlViewerWindowController : NSWindowController <NSOutlineViewDelegate, NSOutlineViewDataSource>

/**
 *  Outline view that shows the xml content
 */
@property (strong, nonatomic) IBOutlet NSOutlineView *outlineView;

/**
 *  The datasoruce
 */
@property (strong, nonatomic) id xmlData;

- (id)initWithWindowNibName:(NSString *)nibOrNil xml:(id)xml;

@end
