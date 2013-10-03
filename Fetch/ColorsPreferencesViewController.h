//
//  ColorsPreferencesViewController.h
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorsPreferencesViewController : NSViewController

@property (strong) IBOutlet NSColorWell *separatorColorWell;
@property (strong) IBOutlet NSColorWell *backgroundColorWell;
@property (strong) IBOutlet NSColorWell *foregroundColorWell;
@property (strong) IBOutlet NSColorWell *successColorWell;
@property (strong) IBOutlet NSColorWell *failureColorWell;

@property (weak) IBOutlet NSButton *jsonSyntaxHighlighting;

-(IBAction)saveColorForProperty:(id)sender;
-(IBAction)jsonSyntaxHighlightingAction:(id)sender;

@end
