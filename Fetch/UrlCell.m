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

-(void)viewWillMoveToSuperview:(NSView *)newSuperview
{
    [super viewWillMoveToSuperview:newSuperview];
    
    [[self pingTimer] invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [[self pingTimer] invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createTimerWithTimeInterval:(NSTimeInterval)timeInterval
{
    __weak UrlCell *blockSelf = self;
    
    _pingTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval block:^{
        UrlCell *strongSelf = blockSelf;
        
        if (![[[self currentUrl] url] isEqualToString:@""] && [[self currentUrl] url]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                BOOL verifyUrl = [strongSelf urlVerification];
                
                if (verifyUrl) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[strongSelf statusImage] setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[strongSelf statusImage] setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
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
    NSHTTPURLResponse *response = nil;
    
    if ([NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]) {
        if ([response statusCode] > 199 && [response statusCode] < 300) {
            return YES;
        }
        else {
            return NO;
        }
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
