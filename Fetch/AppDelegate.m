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
#import "Constants.h"

@interface AppDelegate()

@property (strong, nonatomic) IBOutlet MenuController *menuController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /*
     static NSString *const kJsonSyntaxHighlighting = @"json_syntax_highlighting";
     static NSString *const kPingForReachability = @"ping_for_reachability";
     static NSString *const kFrequencyToPing = @"frequency_to_ping";
     */
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kJsonSyntaxHighlighting: @YES, kPingForReachability: @YES, kFrequencyToPing, @"10"}];
    
    [self setMainWindowController:[[MainWindowController alloc] initWithWindowNibName:@"MainWindow"]];
 
    [[self menuController] setMainWindowController:[self mainWindowController]];

    [[self mainWindowController] showWindow:self];
}

@end
