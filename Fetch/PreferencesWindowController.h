//
//  PreferencesWindowController.h
//  Fetch
//
//  Created by Josh on 9/4/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController <NSControlTextEditingDelegate>

@property (strong) IBOutlet NSColorWell *separatorColorWell;
@property (strong) IBOutlet NSColorWell *backgroundColorWell;
@property (strong) IBOutlet NSColorWell *foregroundColorWell;
@property (strong) IBOutlet NSColorWell *successColorWell;
@property (strong) IBOutlet NSColorWell *failureColorWell;
@property (strong) IBOutlet NSTextField *urlsToRememberTextField;

-(IBAction)saveColorForProperty:(id)sender;

@end
