//
//  ColorsPreferencesViewController.h
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorsPreferencesViewController : NSViewController

/// Reference to NSColorWell that is displaying the specified separator color.
@property (strong) IBOutlet NSColorWell *separatorColorWell;

/// Reference to NSColorWell that is displaying the specified background color.
@property (strong) IBOutlet NSColorWell *backgroundColorWell;

/// Reference to NSColorWell that is displaying the specified foreground color.
@property (strong) IBOutlet NSColorWell *foregroundColorWell;

/// Reference to NSColorWell that is displaying the specified success color.
@property (strong) IBOutlet NSColorWell *successColorWell;

/// Reference to NSColorWell that is displaying the specified failure color.
@property (strong) IBOutlet NSColorWell *failureColorWell;

/**
 * Saves the color for the specified property
 * @sender The NSColorWell object that is calling this method
 */
-(IBAction)saveColorForProperty:(id)sender;

@end
