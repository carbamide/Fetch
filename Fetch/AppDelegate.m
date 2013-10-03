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
#import "NSUserDefaults+NSColor.h"
#import "NSColor+Extensions.h"

@interface AppDelegate()

@property (strong, nonatomic) IBOutlet MenuController *menuController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSColor *defaultSeparatorColor = [NSColor colorWithCalibratedRed:0.194759 green:0.33779 blue:1 alpha:1];
    NSColor *defaultBackgroundColor = [NSColor colorWithCalibratedRed:0.813159 green:0.811473 blue:0.829574 alpha:1];
    NSColor *defaultForegroundColor = [NSColor colorWithCalibratedRed:0.248374 green:0.23825 blue:0.242783 alpha:1];
    NSColor *defaultSuccessColor = [NSColor colorWithCalibratedRed:0.144757 green:0.639582 blue:0.18152 alpha:1];
    NSColor *defaultFailureColor = [NSColor colorWithCalibratedRed:0.680571 green:0.0910357 blue:0.111851 alpha:1];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kJsonSyntaxHighlighting: @YES,
                                                              kPingForReachability: @YES,
                                                              kFrequencyToPing: @"10",
                                                              kSeparatorColor: [defaultSeparatorColor colorForRegisterDefaults],
                                                              kBackgroundColor: [defaultBackgroundColor colorForRegisterDefaults],
                                                              kForegroundColor: [defaultForegroundColor colorForRegisterDefaults],
                                                              kSuccessColor: [defaultSuccessColor colorForRegisterDefaults],
                                                              kFailureColor: [defaultFailureColor colorForRegisterDefaults]
                                                              }];
    
    [self setMainWindowController:[[MainWindowController alloc] initWithWindowNibName:@"MainWindow"]];
 
    [[self menuController] setMainWindowController:[self mainWindowController]];

    [[self mainWindowController] showWindow:self];
}

@end
