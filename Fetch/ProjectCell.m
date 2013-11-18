//
//  ProjectCell.m
//  Fetch
//
//  Created by Josh on 10/1/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ProjectCell.h"
#import "Projects.h"
#import "Constants.h"

@implementation ProjectCell

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

- (void)drawRect:(NSRect)dirtyRect
{
    NSLog(@"%s", __FUNCTION__);
    
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(IBAction)addUrl:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddUrlNotification object:nil userInfo:@{@"project": [self project]}];
}

@end
