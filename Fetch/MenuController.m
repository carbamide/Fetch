//
//  MenuController.m
//  Fetch
//
//  Created by Josh on 9/12/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "Constants.h"
#import "MenuController.h"
#import "PreferencesController.h"
#import "MainWindowController.h"
#import "AppDelegate.h"

@implementation MenuController

-(IBAction)showPreferences:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self preferencesController] showPreferencesWindow:nil];
}

-(IBAction)showMainWindow:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[[[self delegate] mainWindowController] window] makeKeyAndOrderFront:self];
}

-(IBAction)closeWindow:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSWindow *windowToClose = [NSApp mainWindow];
    
    [windowToClose close];
}

-(IBAction)addUrl:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self mainWindowController] addUrl:sender];
}

-(IBAction)importProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self mainWindowController] importProject:sender];
}

-(IBAction)saveLog:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self mainWindowController] saveLog];
}

-(IBAction)findInOutput:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self mainWindowController] findInOutput];
}
@end
