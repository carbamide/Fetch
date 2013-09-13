//
//  JsonViewerWindowController.m
//  Fetch
//
//  Created by Josh on 9/13/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "JsonViewerWindowController.h"

@interface JsonViewerWindowController ()

@property (strong, nonatomic) NSDictionary *jsonDict;

@end

@implementation JsonViewerWindowController

- (id)initWithWindow:(NSWindow *)window json:(id)json
{
    self = [super initWithWindow:window];
    if (self) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            [self setJsonDict:json];
        }
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
