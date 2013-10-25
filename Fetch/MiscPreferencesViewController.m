//
//  MiscPreferencesViewController.m
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "MiscPreferencesViewController.h"
#import "Constants.h"

@implementation MiscPreferencesViewController

-(void)awakeFromNib
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    BOOL checkSiteReachability = [[NSUserDefaults standardUserDefaults] boolForKey:kPingForReachability];
    
    NSString *frequencyToPing = [[NSUserDefaults standardUserDefaults] stringForKey:kFrequencyToPing];
    
    [[self checkSiteReachabilityCheckBox] setState:checkSiteReachability];
    
    if (frequencyToPing) {
        [[self frequencyToPingTextField] setStringValue:frequencyToPing];
    }
    
    if ([[self checkSiteReachabilityCheckBox] state] == NSOnState) {
        [[self frequencyToPingLabel] setEnabled:YES];
        [[self frequencyToPingStepper] setEnabled:YES];
        [[self frequencyToPingTextField] setEnabled:YES];
    }
    else {
        [[self frequencyToPingLabel] setEnabled:NO];
        [[self frequencyToPingStepper] setEnabled:NO];
        [[self frequencyToPingTextField] setEnabled:NO];
    }
}

-(IBAction)pingReachabilityAction:(id)sender
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    if ([[self checkSiteReachabilityCheckBox] state] == NSOnState) {
        [[self frequencyToPingLabel] setEnabled:YES];
        [[self frequencyToPingStepper] setEnabled:YES];
        [[self frequencyToPingTextField] setEnabled:YES];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPingForReachability];
    }
    else {
        [[self frequencyToPingLabel] setEnabled:NO];
        [[self frequencyToPingStepper] setEnabled:NO];
        [[self frequencyToPingTextField] setEnabled:NO];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kPingForReachability];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [[NSUserDefaults standardUserDefaults] setValue:[[self frequencyToPingTextField] stringValue] forKey:kFrequencyToPing];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
