//
//  AppDelegate.m
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "MenuController.h"

@interface AppDelegate()

@property (strong, nonatomic) IBOutlet MenuController *menuController;
@property (strong, nonatomic) MainWindowController *mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setMainWindowController:[[MainWindowController alloc] initWithWindowNibName:@"MainWindow"]];
    
    [[self mainWindowController] showWindow:self];
}

@end
