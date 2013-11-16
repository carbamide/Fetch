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
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    if (_objectCount > 0) {
        NSString *returnString = nil;
        
        returnString = [NSString stringWithFormat:@"%@ - %ld %@", _nodeTitle, (long)_objectCount, _objectCount == 1 ? @"object" : @"objects"];
        
        return returnString;
    }
    else {
        return _nodeTitle;
    }
}

@end
