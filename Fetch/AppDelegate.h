//
//  AppDelegate.h
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) NSWindow *window;
@property (strong, nonatomic) MainWindowController *mainWindowController;

@end
