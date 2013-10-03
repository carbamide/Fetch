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
#import "Reachability.h"
#import "NSTimer+Blocks.h"

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
    
    _pingTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 block:^{
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

-(void)dealloc
{
    [[self pingTimer] invalidate];
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

-(BOOL)isUrlUp
{
    if ([[[self currentUrl] url] isEqualToString:@""]) {
        return NO;
    }
    
    SCNetworkReachabilityRef target;
    SCNetworkConnectionFlags flags = 0;
    
    BOOL ok;
    
    target = SCNetworkReachabilityCreateWithName(NULL, [[[self currentUrl] url] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    ok = SCNetworkReachabilityGetFlags(target, &flags);
    
    //CFRelease(target);
    
    return ok;
}



@end
