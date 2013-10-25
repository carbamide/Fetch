//
//  MenuController.m
//  Fetch
//
//  Created by Josh on 9/12/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "MenuController.h"
#import "PreferencesController.h"
#import "MainWindowController.h"
#import "AppDelegate.h"

@implementation MenuController

-(IBAction)showPreferences:(id)sender
{
    #ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [[self preferencesController] showPreferencesWindow:nil];
}

-(IBAction)showMainWindow:(id)sender
{
    #ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [[[[self delegate] mainWindowController] window] makeKeyAndOrderFront:self];
}

-(IBAction)closeWindow:(id)sender
{
    #ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    for (NSWindow *tempWindow in [[NSApp windows] objectEnumerator]) {
        if ([tempWindow isVisible]) {
            [tempWindow close];
            break;
        }
    }
}

-(IBAction)addUrl:(id)sender
{
    #ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    [[self mainWindowController] addUrl:sender];
}

-(IBAction)importProject:(id)sender
{
    #ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [[self mainWindowController] importProject:sender];
}

-(IBAction)saveLog:(id)sender
{
    #ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    [[self mainWindowController] saveLog];
}
@end
