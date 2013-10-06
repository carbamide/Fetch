//
//  PreferencesController.h
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject

@property (readwrite, strong, nonatomic) IBOutlet NSWindow *window;

- (IBAction)showPreferencesFor:(id)sender;

- (void)showPreferencesWindow:(id)sender;

@end
