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
    NSLog(@"%s", __FUNCTION__);
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

-(void)awakeFromNib
{
    NSLog(@"%s", __FUNCTION__);
    
    [super awakeFromNib];
    
    [[self textField] setEditable:NO];
    [[self textField] setSelectable:NO];
}

-(void)viewWillMoveToSuperview:(NSView *)newSuperview
{
    NSLog(@"%s", __FUNCTION__);
    
    [super viewWillMoveToSuperview:newSuperview];
    
    [[self pingTimer] invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self pingTimer] invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSLog(@"%s", __FUNCTION__);
    
	[super drawRect:dirtyRect];
}

@end
