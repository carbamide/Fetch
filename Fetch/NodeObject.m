//
//  NodeObject.m
//  Fetch
//
//  Created by Josh on 9/15/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NodeObject.h"

@implementation NodeObject

-(NSString *)nodeTitle
{
    if (_objectCount > 0) {
        NSString *returnString = nil;
        
        if (_objectCount == 1) {
            returnString = [NSString stringWithFormat:@"%@ - %ld object", _nodeTitle, (long)_objectCount];
        }
        else {
            returnString = [NSString stringWithFormat:@"%@ - %ld objects", _nodeTitle, (long)_objectCount];
        }
        
        return returnString;
    }
    else {
        return _nodeTitle;
    }
}

@end
