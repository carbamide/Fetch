//
//  UrlCell.m
//  Fetch for OSX
//
//  Created by Josh on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "UrlCell.h"

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
    
    [[self textField] setEditable:NO];
    [[self textField] setSelectable:NO];
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
