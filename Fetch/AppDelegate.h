//
//  AppDelegate.h
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "ViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) IBOutlet ViewController *viewController;

@property (strong, nonatomic) PreferencesWindowController *preferencesWindow;

-(IBAction)showPreferences:(id)sender;
-(IBAction)showProjects:(id)sender;
-(IBAction)openProject:(id)sender;
-(IBAction)closeWindow:(id)sender;

-(IBAction)showMainWindow:(id)sender;

@end
