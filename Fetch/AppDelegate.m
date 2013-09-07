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
    // Insert code here to initialize your application
}

-(IBAction)showPreferences:(id)sender
{
    if (![self preferencesWindow]) {
        _preferencesWindow = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    }
    
    [[_preferencesWindow window] makeKeyAndOrderFront:self];
}

@end
