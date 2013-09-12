//
//  MenuController.h
//  Fetch
//
//  Created by Josh on 9/12/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController, PreferencesWindowController, AppDelegate;

@interface MenuController : NSObject

@property (strong, nonatomic) IBOutlet ViewController *viewController;
@property (strong, nonatomic) PreferencesWindowController *preferencesWindow;
@property (weak, nonatomic) IBOutlet AppDelegate *delegate;

-(IBAction)showPreferences:(id)sender;
-(IBAction)showProjects:(id)sender;
-(IBAction)closeWindow:(id)sender;

-(IBAction)showMainWindow:(id)sender;

-(IBAction)exportProject:(id)sender;
-(IBAction)importProject:(id)sender;
-(IBAction)deleteProject:(id)sender;

@end
