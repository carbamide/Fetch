//
//  PreferencesController.h
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject

#pragma mark Properties
@property (readwrite, strong, nonatomic) IBOutlet NSWindow *window;

#pragma mark Actions
- (IBAction)showPreferencesFor:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

@end
