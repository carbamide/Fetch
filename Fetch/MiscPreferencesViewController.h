//
//  MiscPreferencesViewController.h
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MiscPreferencesViewController : NSViewController <NSControlTextEditingDelegate>

@property (strong, nonatomic) IBOutlet NSButton *checkSiteReachabilityCheckBox;
@property (strong) IBOutlet NSTextField *frequencyToPingLabel;
@property (strong) IBOutlet NSTextField *frequencyToPingTextField;
@property (strong) IBOutlet NSStepper *frequencyToPingStepper;

@property (nonatomic) int pingFrequency;

-(IBAction)pingReachabilityAction:(id)sender;

@end
