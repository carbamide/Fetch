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

@property (strong, nonatomic) IBOutlet MainWindowController *mainWindowController;
@property (strong, nonatomic) IBOutlet PreferencesController *preferencesController;
@property (weak, nonatomic) IBOutlet AppDelegate *delegate;

-(IBAction)showPreferences:(id)sender;
-(IBAction)closeWindow:(id)sender;

-(IBAction)showMainWindow:(id)sender;

-(IBAction)addUrl:(id)sender;
-(IBAction)exportProject:(id)sender;
-(IBAction)importProject:(id)sender;
-(IBAction)deleteProject:(id)sender;
-(IBAction)saveLog:(id)sender;

@end
