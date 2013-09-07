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
        NSColor *color = nil;
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] dataForKey:preferenceKeys[i]];
        
        color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];

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
}

-(IBAction)saveColorForProperty:(id)sender
{
    NSColorWell *colorWell = sender;
    
    NSData *colorData = [NSArchiver archivedDataWithRootObject:[colorWell color]];

    switch ([sender tag]) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kSeparatorColor];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kBackgroundColor];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kForegroundColor];

            break;
        case 3:
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kSuccessColor];

            break;
        case 4:
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kFailureColor];

            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
