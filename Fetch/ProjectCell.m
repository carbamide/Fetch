//
//  ProjectCell.m
//  Fetch
//
//  Created by Josh on 10/1/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ProjectCell.h"
#import "Projects.h"

@implementation ProjectCell

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(IBAction)addUrl:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_URL" object:nil userInfo:@{@"project": [self project]}];
}

@end
