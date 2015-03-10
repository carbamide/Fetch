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
    [[self preferencesController] showPreferencesWindow:nil];
}

-(IBAction)showMainWindow:(id)sender
{
    [[[[self delegate] mainWindowController] window] makeKeyAndOrderFront:self];
}

-(IBAction)closeWindow:(id)sender
{
    NSWindow *windowToClose = [NSApp mainWindow];
    
    [windowToClose close];
}

-(IBAction)addUrl:(id)sender
{
    [[self mainWindowController] addUrl:sender];
}

-(IBAction)importProject:(id)sender
{
    [[self mainWindowController] importProject:sender];
}

-(IBAction)saveLog:(id)sender
{
    [[self mainWindowController] saveLog];
}

-(IBAction)findInOutput:(id)sender
{
    [[self mainWindowController] findInOutput];
}

-(IBAction)cloneHeaders:(id)sender
{

    [[self mainWindowController] cloneHeaders:sender];
}

@end
