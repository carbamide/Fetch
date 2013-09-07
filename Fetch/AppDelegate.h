//
//  AppDelegate.h
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) PreferencesWindowController *preferencesWindow;

-(IBAction)showPreferences:(id)sender;

@end
