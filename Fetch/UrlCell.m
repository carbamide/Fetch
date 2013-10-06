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


- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

@end
