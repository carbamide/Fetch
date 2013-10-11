//
//  UrlCell.h
//  Fetch for OSX
//
//  Created by Josh on 10/2/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Urls;

@interface UrlCell : NSTableCellView

/// Shows the current up, down, or indeterminate status of the url specified in currentURL
@property (strong, nonatomic) IBOutlet NSImageView *statusImage;

/// The URLs object that the cell is showing
@property (strong, nonatomic) Urls *currentUrl;

@end
