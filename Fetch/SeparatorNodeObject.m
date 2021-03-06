//
//  SeparatorNodeObject.m
//  Fetch
//
//  Created by Josh on 9/16/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "SeparatorNodeObject.h"

@implementation SeparatorNodeObject

-(id)init
{
    self = [super init];
    
    if (self) {
        [self setNodeTitle:[NSString string]];
        [self setNodeValue:[NSString string]];
        [self setIsArray:NO];
        [self setIsLeaf:YES];
    }
    
    return self;
}

@end
