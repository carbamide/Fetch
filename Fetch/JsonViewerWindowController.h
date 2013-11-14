//
//  JsonViewerWindowController.h
//  Fetch
//
//  Created by Josh on 9/13/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JsonViewerWindowController : NSWindowController <NSOutlineViewDataSource, NSOutlineViewDelegate>

/// The outline view that shows a representation of the specified JSON data
@property (strong, nonatomic) IBOutlet NSOutlineView *outlineView;

/// The JSON data to represent in outlineView
@property (strong, nonatomic) id jsonData;

/**
 * Initialization
 * @param nibOrNil Name of nib or nil
 * @param json JSON data that the user wishes to represent in JsonViewerWindowController
 * @return JsonViewerWindowController object
 */
- (id)initWithWindowNibName:(NSString *)nibOrNil json:(id)json;

@end
