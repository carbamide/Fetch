//
//  ColorsPreferencesViewController.m
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ColorsPreferencesViewController.h"
#import "Constants.h"
#import "NSUserDefaults+NSColor.h"
#import "NSColor+Extensions.h"

@implementation ColorsPreferencesViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

    }
    
    return self;
}

- (void)awakeFromNib
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [super awakeFromNib];
    
    NSColor *defaultSeparatorColor = [NSColor colorWithCalibratedRed:0.194759 green:0.33779 blue:1 alpha:1];
    NSColor *defaultBackgroundColor = [NSColor colorWithCalibratedRed:0.813159 green:0.811473 blue:0.829574 alpha:1];
    NSColor *defaultForegroundColor = [NSColor colorWithCalibratedRed:0.248374 green:0.23825 blue:0.242783 alpha:1];
    NSColor *defaultSuccessColor = [NSColor colorWithCalibratedRed:0.144757 green:0.639582 blue:0.18152 alpha:1];
    NSColor *defaultFailureColor = [NSColor colorWithCalibratedRed:0.680571 green:0.0910357 blue:0.111851 alpha:1];
    
    NSArray *defaultColors = @[defaultSeparatorColor, defaultBackgroundColor, defaultForegroundColor, defaultSuccessColor, defaultFailureColor];
    
    NSArray *preferenceKeys = @[kSeparatorColor, kBackgroundColor, kForegroundColor, kSuccessColor, kFailureColor];
    
    for (int i = 0; i < [preferenceKeys count]; i++) {
        NSColor *color = [[NSUserDefaults standardUserDefaults] colorForKey:preferenceKeys[i]] ? [[NSUserDefaults standardUserDefaults] colorForKey:preferenceKeys[i]] : defaultColors[i];

        switch (i) {
            case 0:
                [[self separatorColorWell] setColor:color];
                break;
            case 1:
                [[self backgroundColorWell] setColor:color];
                break;
            case 2:
                [[self foregroundColorWell] setColor:color];
                break;
            case 3:
                [[self successColorWell] setColor:color];
                break;
            case 4:
                [[self failureColorWell] setColor:color];
                break;
            default:
                break;
        }
    }
    
    BOOL syntaxHighting = [[NSUserDefaults standardUserDefaults] boolForKey:kJsonSyntaxHighlighting];
    
    [[self jsonSyntaxHighlighting] setState:syntaxHighting];
}

-(IBAction)saveColorForProperty:(id)sender
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    NSColorWell *colorWell = sender;
    
    switch ([sender tag]) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setColor:[colorWell color] forKey:kSeparatorColor];
            
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setColor:[colorWell color] forKey:kBackgroundColor];
            
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setColor:[colorWell color] forKey:kForegroundColor];
            
            break;
        case 3:
            [[NSUserDefaults standardUserDefaults] setColor:[colorWell color] forKey:kSuccessColor];
            
            break;
        case 4:
            [[NSUserDefaults standardUserDefaults] setColor:[colorWell color] forKey:kFailureColor];
            
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)jsonSyntaxHighlightingAction:(id)sender
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    NSButton *checkbox = sender;
    
    if ([checkbox state] == NSOnState) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kJsonSyntaxHighlighting];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kJsonSyntaxHighlighting];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

