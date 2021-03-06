//
//  NSView+CNSplitViewToolbar.m
//  CNSplitView Example
//
//  Created by Frank Gregor on 04.02.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

@import ObjectiveC.runtime;
#import "NSView+CNSplitViewToolbar.h"


static char toolbarItemAlignKey, toolbarItemWidthKey;

@implementation NSView (CNSplitViewToolbar)

- (CNSplitViewToolbarItemAlign)toolbarItemAlign
{
    NSNumber *number = objc_getAssociatedObject(self, &toolbarItemAlignKey);
    return (CNSplitViewToolbarItemAlign)[number integerValue];
}
- (void)setToolbarItemAlign:(CNSplitViewToolbarItemAlign)theAlign
{
    objc_setAssociatedObject(self, &toolbarItemAlignKey, [NSNumber numberWithInteger:theAlign], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)toolbarItemWidth
{
    NSNumber *number = objc_getAssociatedObject(self, &toolbarItemWidthKey);
    return (CGFloat)[number doubleValue];
}
- (void)setToolbarItemWidth:(CGFloat)theItemWidth
{
    objc_setAssociatedObject(self, &toolbarItemWidthKey, [NSNumber numberWithDouble:theItemWidth], OBJC_ASSOCIATION_RETAIN);
}


@end
