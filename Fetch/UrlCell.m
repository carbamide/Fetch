//
//  UrlCell.m
//  Fetch for OSX
//
//  Created by Josh on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>

#import "UrlCell.h"
#import "Urls.h"
#import "NSTimer+Blocks.h"
#import "Constants.h"

@interface UrlCell()
@property (strong, nonatomic) NSTimer *pingTimer;
@property (nonatomic) dispatch_queue_t lowQueue;

@end
@implementation UrlCell

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[self statusImage] setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChanges:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    BOOL checkSiteReachability = [[NSUserDefaults standardUserDefaults] boolForKey:kPingForReachability];
    
    NSString *frequencyToPing = [[NSUserDefaults standardUserDefaults] stringForKey:kFrequencyToPing];
    
    if (checkSiteReachability) {
        [self createTimerWithTimeInterval:[frequencyToPing intValue]];
    }
    else {
        [[self statusImage] setHidden:YES];
    }
}

-(void)dealloc
{
    [[self pingTimer] invalidate];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

-(void)createTimerWithTimeInterval:(NSTimeInterval)timeInterval
{
    _pingTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval block:^{
        if (![[[self currentUrl] url] isEqualToString:@""]) {
            
            if (!_lowQueue) {
                _lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            }
            
            dispatch_async(_lowQueue, ^{
                BOOL verifyUrl = [self urlVerification];
                
                if (verifyUrl) {
                    NSLog(@"%@ is up!", [[self currentUrl] url]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[self statusImage] setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
                    });
                }
                else {
                    NSLog(@"%@ is down!", [[self currentUrl] url]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[self statusImage] setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
                    });
                }
            });
        }
    } repeats:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(BOOL)urlVerification
{
    NSURL *url = [NSURL URLWithString:[[self currentUrl] url]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    if ([NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]) {
        return YES;
    }
    return NO;
}

-(void)preferencesChanges:(NSNotification *)aNotification
{
    BOOL checkSiteReachability = [[NSUserDefaults standardUserDefaults] boolForKey:kPingForReachability];
    
    NSString *frequencyToPing = [[NSUserDefaults standardUserDefaults] stringForKey:kFrequencyToPing];
    
    if (checkSiteReachability) {
        if ([_pingTimer isValid]) {
            [_pingTimer invalidate];
        }
        
        [self createTimerWithTimeInterval:[frequencyToPing intValue]];
        
        [[self statusImage] setHidden:NO];
    }
    else {
        [[self pingTimer] invalidate];
        
        [[self statusImage] setHidden:YES];
    }
}


@end
