//
//  JsonViewerWindowController.h
//  Fetch
//
//  Created by Josh on 9/13/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JsonViewerWindowController : NSWindowController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (strong, nonatomic) IBOutlet NSOutlineView *outlineView;
@property (strong, nonatomic) id jsonData;

- (id)initWithWindowNibName:(NSString *)nibOrNil json:(id)json;

@end
