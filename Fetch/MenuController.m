//
//  MenuController.m
//  Fetch
//
//  Created by Josh on 9/12/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "MenuController.h"
#import "PreferencesWindowController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface MenuController()

@end

@implementation MenuController

-(id)initWithDelegate:(AppDelegate *)delegate
{
    self = [super init];
    
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

-(IBAction)showPreferences:(id)sender
{
    if (![self preferencesWindow]) {
        _preferencesWindow = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    }
    
    [[_preferencesWindow window] makeKeyAndOrderFront:self];
}

-(IBAction)showProjects:(id)sender
{
    [[self viewController] showProjects];
}

-(IBAction)showMainWindow:(id)sender
{
    [[[self delegate] window] makeKeyAndOrderFront:self];
}

-(IBAction)closeWindow:(id)sender
{
    for (NSWindow *tempWindow in [[NSApp windows] reverseObjectEnumerator]) {
        if ([tempWindow isVisible]) {
            [tempWindow close];
            break;
        }
    }
}

-(IBAction)exportProject:(id)sender
{
    [[self viewController] exportProject:sender];
}

-(IBAction)importProject:(id)sender
{
    [[self viewController] importProject:sender];
}

-(IBAction)deleteProject:(id)sender
{
    [[self viewController] deleteProject:sender];
}

@end
