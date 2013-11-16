//
//  PlistViewerWindowController.h
//  Fetch for OSX
//
//  Created by Joshua Barrow on 11/15/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

/**
 *  XML Viewer
 */
@interface PlistViewerWindowController : NSWindowController <NSOutlineViewDelegate, NSOutlineViewDataSource>

/**
 *  Outline view that shows the xml content
 */
@property (strong, nonatomic) IBOutlet NSOutlineView *outlineView;

/**
 *  The datasoruce
 */
@property (strong, nonatomic) id plistData;

- (id)initWithWindowNibName:(NSString *)nibOrNil plist:(id)plist;

@end
