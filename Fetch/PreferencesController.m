//
//  PreferencesController.m
//  Fetch
//
//  Created by Joshua Barrow on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PreferencesController.h"
#import "ColorsPreferencesViewController.h"
#import "MiscPreferencesViewController.h"

@interface PreferencesController ()

@property (nonatomic, strong, readwrite) NSArray *viewControllers;
@property (nonatomic, strong) NSViewController *currentViewController;
@property (nonatomic, strong) NSToolbarItem *currentToolbarItem;

- (void)createToolbarItemsToViewControllerMapping;
- (NSViewController *)createViewControllerForToolbarItem:(NSToolbarItem *)item;
- (NSViewController *)existingViewControllerForToolbarItem:(NSToolbarItem *)item;

@end

@implementation PreferencesController

- (void)awakeFromNib
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    if ([super respondsToSelector:_cmd]) {
        [super awakeFromNib];
    }
    
    [self createToolbarItemsToViewControllerMapping];
}

- (IBAction)showPreferencesFor:(id)sender
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    NSViewController *newViewController = [self existingViewControllerForToolbarItem:sender];
    
    if (![self currentViewController]) {
        CGFloat deltaHeight = NSHeight([[[self window] contentView] bounds]) - NSHeight([[newViewController view] frame]);
        CGFloat deltaWidth = NSWidth([[[self window] contentView] bounds]) - NSWidth([[newViewController view] frame]);
        
        NSRect newWindowFrame = [[self window] frame];
        
        newWindowFrame.size.height -= deltaHeight;
        newWindowFrame.size.width -= deltaWidth;
        newWindowFrame.origin.y += deltaHeight;
        
        [[self window] setFrame:newWindowFrame display:YES animate:YES];
        [[[self window] contentView] addSubview:[newViewController view]];
        
        [self setCurrentViewController:newViewController];
        
        return;
    }
    
    [[[self currentViewController] view] removeFromSuperview];
    
    CGFloat deltaHeight = NSHeight([[[self currentViewController] view] frame]) - NSHeight([[newViewController view] frame]);
    CGFloat deltaWidth = NSWidth([[[self currentViewController] view] frame]) - NSWidth([[newViewController view] frame]);
    
    NSRect newWindowFrame = self.window.frame;
    
    newWindowFrame.size.height -= deltaHeight;
    newWindowFrame.size.width -= deltaWidth;
    newWindowFrame.origin.y += deltaHeight;
    
    [[self window] setFrame:newWindowFrame display:YES animate:YES];
    [[[self window] contentView] addSubview:[newViewController view]];
    
    [self setCurrentViewController:newViewController];
}

- (void)showPreferencesWindow:(id)sender
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [[self window] center];
    [[self window] makeKeyAndOrderFront:sender];
}

- (void)createToolbarItemsToViewControllerMapping
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    [self setViewControllers:[NSArray array]];
    
    if (![self window]) {
        NSLog(@"A preferences controller cannot work without a window. Connect the window outlet to your preferences window.");
        
        return;
    }
    
    if (![[self window] toolbar]) {
        NSLog(@"A preferences controller cannot work without a toolbar.");
        
        return;
    }
    
    NSToolbarItem *firstItem = nil;
    
    for (NSToolbarItem *visibleItem in [[[self window] toolbar] visibleItems]) {
        if (![visibleItem isEnabled] || [visibleItem target] != self) {
            continue;
        }
        
        NSViewController *controller = [self createViewControllerForToolbarItem:visibleItem];
        
        if (controller == nil) {
            continue;
        }
        
        [self setViewControllers:[[self viewControllers] arrayByAddingObject:controller]];
        
        if (!firstItem) {
            firstItem = visibleItem;
        }
    }
    
    if (firstItem) {
        [[[self window] toolbar] setSelectedItemIdentifier:[firstItem itemIdentifier]];
        
        [self showPreferencesFor:firstItem];
    }
}

- (NSViewController *)createViewControllerForToolbarItem:(NSToolbarItem *)item
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    if (!item) {
        return nil;
    }
    
    NSViewController *result = nil;
    
    NSString *identifier = [item itemIdentifier];
    
    if ([identifier isEqualToString:@"ColorsPreferencesViewController"]) {
        result = [[ColorsPreferencesViewController alloc] initWithNibName:identifier bundle:nil];
    }
    else if ([identifier isEqualToString:@"MiscPreferencesViewController"]) {
        result = [[MiscPreferencesViewController alloc] initWithNibName:identifier bundle:nil];
    }
    
    if (result == nil) {
        return nil;
    }
    
    [result view];
    
    return result;
}

- (NSViewController *)existingViewControllerForToolbarItem:(NSToolbarItem *)item
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    if (item == nil) {
        return nil;
    }
    
    NSString *identifier = [item itemIdentifier];
    
    for (NSViewController *viewController in [self viewControllers]) {
        if ([[viewController nibName] isEqualToString:identifier]) {
            return viewController;
        }
    }
    
    return nil;
}

@end
