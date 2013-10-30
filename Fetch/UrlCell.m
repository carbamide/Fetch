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
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

-(void)awakeFromNib
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    [super awakeFromNib];
    
    [[self textField] setEditable:NO];
    [[self textField] setSelectable:NO];
}

-(void)viewWillMoveToSuperview:(NSView *)newSuperview
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [super viewWillMoveToSuperview:newSuperview];
    
    [[self pingTimer] invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [[self pingTimer] invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(NSRect)dirtyRect
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

	[super drawRect:dirtyRect];
}

@end
