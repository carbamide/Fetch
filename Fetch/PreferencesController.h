//
//  PreferencesController.h
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject

/// The PreferencesController window
@property (readwrite, strong, nonatomic) IBOutlet NSWindow *window;

/**
 * Method to show the preferences NSViewController for the specified sender
 * @param sender The caller of this method
 */
- (IBAction)showPreferencesFor:(id)sender;

/** 
 * Show the preferences window if hidden
 * @param sender The caller of this action
 */
- (void)showPreferencesWindow:(id)sender;

@end
