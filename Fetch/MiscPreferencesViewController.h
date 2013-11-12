//
//  MiscPreferencesViewController.h
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MiscPreferencesViewController : NSViewController <NSControlTextEditingDelegate>

/// Button (checkbox) that lets the user decide whether to check site reachability
@property (strong, nonatomic) IBOutlet NSButton *checkSiteReachabilityCheckBox;

/// Label for frequencyToPingTextField
@property (strong) IBOutlet NSTextField *frequencyToPingLabel;

/**
 *  Label for frequencyToPingTextField
 */
@property (strong) IBOutlet NSTextField *frequencyToPingSecondsLabel;

/// TextField that lets the user specify how often to check the site reachability
@property (strong) IBOutlet NSTextField *frequencyToPingTextField;

/// Stepper to let the user increment the interval to check site reachability
@property (strong) IBOutlet NSStepper *frequencyToPingStepper;

/**
 *  Button that allows the user to select whether or not to attemp to parse HTML in the output from the fetch
 */
@property (strong) IBOutlet NSButton *attemptToParseHtmlButton;

/// Backing store for frequencyToPingTextField
@property (nonatomic) int pingFrequency;

/**
 * Method to save user preference of whether or not to ping sites for reachability
 * @param sender The caller of this method
 */
-(IBAction)pingReachabilityAction:(id)sender;

/**
 *  Action that sets whether or not to attempt to parse html output in the outputTextView
 *
 *  @param sender The caller of this method
 */
-(IBAction)parseAction:(id)sender;

@end
