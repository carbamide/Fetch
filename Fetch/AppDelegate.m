//
//  AppDelegate.m
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

-(IBAction)showPreferences:(id)sender
{
    if (![self preferencesWindow]) {
        _preferencesWindow = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    }
    
    [[_preferencesWindow window] makeKeyAndOrderFront:self];
}

-(IBAction)newProject:(id)sender
{
    //not implemented
}

-(IBAction)openProject:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            // do something with the url here.
        }
    }
}

-(IBAction)showMainWindow:(id)sender
{
    [[self window] makeKeyAndOrderFront:self];
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

@end
