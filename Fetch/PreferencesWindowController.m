//
//  PreferencesWindowController.m
//  Fetch
//
//  Created by Josh on 9/4/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "NSUserDefaults+NSColor.h"
#import "Constants.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSArray *preferenceKeys = @[kSeparatorColor, kBackgroundColor, kForegroundColor, kSuccessColor, kFailureColor];
    
    for (int i = 0; i < [preferenceKeys count]; i++) {
        NSColor *color = [[NSUserDefaults standardUserDefaults] colorForKey:preferenceKeys[i]];

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
