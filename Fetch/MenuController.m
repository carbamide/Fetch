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

-(IBAction)showPreferences:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    if (![self preferencesWindow]) {
        _preferencesWindow = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    }
    
    [[_preferencesWindow window] makeKeyAndOrderFront:self];
}

-(IBAction)showProjects:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self viewController] showProjects];
}

-(IBAction)showMainWindow:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[[self delegate] window] makeKeyAndOrderFront:self];
}

-(IBAction)closeWindow:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    for (NSWindow *tempWindow in [[NSApp windows] reverseObjectEnumerator]) {
        if ([tempWindow isVisible]) {
            [tempWindow close];
            break;
        }
    }
}

-(IBAction)addUrl:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self viewController] addUrl:sender];
}

-(IBAction)exportProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self viewController] exportProject:sender];
}

-(IBAction)importProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self viewController] importProject:sender];
}

-(IBAction)deleteProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    [[self viewController] deleteProject:sender];
}

@end
