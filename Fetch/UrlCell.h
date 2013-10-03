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

@property (strong, nonatomic) IBOutlet NSImageView *statusImage;

@property (strong, nonatomic) Urls *currentUrl;

@end
