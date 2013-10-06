//
//  ViewController.h
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "CNSplitView.h"
#import "MenuController.h"

@class JsonViewerWindowController;

@interface MainWindowController : NSWindowController <NSControlTextEditingDelegate, NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDataSource, NSComboBoxDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate, NSMenuDelegate, CNSplitViewToolbarDelegate, NSSplitViewDelegate, NSDraggingDestination>

@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSTextField *urlDescriptionTextField;
@property (weak) IBOutlet NSComboBox *methodCombo;
@property (weak) IBOutlet NSButton *fetchButton;
@property (weak) IBOutlet NSButton *customPostBodyCheckBox;
@property (weak) IBOutlet NSButton *logRequestCheckBox;
@property (weak) IBOutlet NSButton *clearOutputButton;
@property (weak) IBOutlet NSButton *jsonOutputButton;
@property (weak) IBOutlet NSTableView *headersTableView;
@property (weak) IBOutlet NSTableView *parametersTableView;
@property (weak) IBOutlet NSSegmentedControl *headerSegCont;
@property (weak) IBOutlet NSSegmentedControl *paramSegCont;
@property (weak) IBOutlet NSOutlineView *projectSourceList;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (unsafe_unretained) IBOutlet NSTextView *customPayloadTextView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTableView *requestTableView;
@property (weak) IBOutlet NSTableView *responseTableView;
@property (strong) IBOutlet CNSplitView *splitView;
@property (strong, nonatomic) IBOutlet MenuController *menuController;

@property (strong, nonatomic) JsonViewerWindowController *jsonWindow;

@property (strong, nonatomic) NSDictionary *requestDict;
@property (strong, nonatomic) NSDictionary *responseDict;

-(IBAction)fetchAction:(id)sender;
-(IBAction)headerSegContAction:(id)sender;
-(IBAction)parameterSegContAction:(id)sender;
-(IBAction)customPostBodyAction:(id)sender;
-(IBAction)clearOutput:(id)sender;
-(IBAction)showJson:(id)sender;

-(void)exportProject:(id)sender;
-(void)importProject:(id)sender;
-(void)deleteProject:(id)sender;
-(void)addUrl:(id)sender;
-(void)saveLog;

@end
