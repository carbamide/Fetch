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

@interface MenuController()

@end

@implementation MenuController

-(IBAction)showPreferences:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self preferencesController] showPreferencesWindow:nil];
}

-(IBAction)showMainWindow:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[[self delegate] window] makeKeyAndOrderFront:self];
}

-(IBAction)closeWindow:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    for (NSWindow *tempWindow in [[NSApp windows] objectEnumerator]) {
        if ([tempWindow isVisible]) {
            [tempWindow close];
            break;
        }
    }
}

-(IBAction)addUrl:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self mainWindowController] addUrl:sender];
}

-(IBAction)exportProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self mainWindowController] exportProject:sender];
}

-(IBAction)importProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self mainWindowController] importProject:sender];
}

-(IBAction)deleteProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self mainWindowController] deleteProject:sender];
}

-(IBAction)saveLog:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self mainWindowController] saveLog];
}
@end
