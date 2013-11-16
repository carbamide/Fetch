//
//  MenuController.h
//  Fetch
//
//  Created by Josh on 9/12/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainWindowController, PreferencesController, AppDelegate;

@interface MenuController : NSObject

/// MainWindowController object
@property (strong, nonatomic) MainWindowController *mainWindowController;

/// PreferencesController object
@property (strong, nonatomic) IBOutlet PreferencesController *preferencesController;

/// AppDelegate object
@property (weak, nonatomic) IBOutlet AppDelegate *delegate;

/**
 * Shows the prefernce window
 * @param sender The caller of this method
 */
-(IBAction)showPreferences:(id)sender;

/**
 * Closes the prefernce window
 * @param sender The caller of this method
 */
-(IBAction)closeWindow:(id)sender;

/**
 * Shows the main window
 * @param sender The caller of this method
 */
-(IBAction)showMainWindow:(id)sender;

/**
 * Adds url to currentProject of mainWindowController
 * @param sender The caller of this method
 */
-(IBAction)addUrl:(id)sender;

/**
 * Begins the import process
 * @param sender The caller of this method
 */
-(IBAction)importProject:(id)sender;

/**
 * Saves current output of mainWindowController's outputTextView to file
 * @param sender The caller of this method
 */
-(IBAction)saveLog:(id)sender;

/**
 *  Find text in MainWindowController's outputTextView
 *
 *  @param sender The caller of this method
 */
-(IBAction)findInOutput:(id)sender;
@end
