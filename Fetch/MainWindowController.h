//
//  ViewController.h
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "CNSplitView.h"
#import "MenuController.h"

@class JsonViewerWindowController, CsvViewerWindowController;

@interface MainWindowController : NSWindowController <NSControlTextEditingDelegate, NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDataSource, NSComboBoxDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate, NSMenuDelegate, CNSplitViewToolbarDelegate, NSSplitViewDelegate, NSDraggingDestination>

/// The url text field
@property (weak) IBOutlet NSTextField *urlTextField;

// The text field that holds a description of the current url
@property (weak) IBOutlet NSTextField *urlDescriptionTextField;

/// Lets the user specify the HTTP method to use when fetching the current url
@property (weak) IBOutlet NSComboBox *methodCombo;

/// Button for performing the fetch action
@property (weak) IBOutlet NSButton *fetchButton;

/// Button that shows or hides an NSTextView that allows the user to specify custom data to pass when fetching
@property (weak) IBOutlet NSButton *customPostBodyCheckBox;

/// NSButton (checkbox) that lets the user specify whether the request to the server should be logged to output
@property (weak) IBOutlet NSButton *logRequestCheckBox;

/// NSButton that clears the output in the main window
@property (weak) IBOutlet NSButton *clearOutputButton;

/// NSButton that is used to show the JSON output window
@property (weak) IBOutlet NSButton *jsonOutputButton;

/// Table that shows the headers and allows you to add additional headers
@property (weak) IBOutlet NSTableView *headersTableView;

/// Table that shows the parameters and allows you to add additional parameters
@property (weak) IBOutlet NSTableView *parametersTableView;

/// Segmented control that allows you to add or remove headers from the headersTableView
@property (weak) IBOutlet NSSegmentedControl *headerSegCont;

/// Segmented control that allows you to add or remove parameters from the parametersTableView
@property (weak) IBOutlet NSSegmentedControl *paramSegCont;

/// NSOutlineView that shows the Projects that have been saved and their associated URLs
@property (weak) IBOutlet NSOutlineView *projectSourceList;

/// Output of the fetch request
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;

/// Text view that allows you to specify a custom payload for the fetch request
@property (unsafe_unretained) IBOutlet NSTextView *customPayloadTextView;

/// Indeterminate progress indicator that shows when a fetch request it being made and hides when it is completed
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

/// Table that shows the headers from the request
@property (weak) IBOutlet NSTableView *requestTableView;

/// Table that shows the response headers from the fetch request
@property (weak) IBOutlet NSTableView *responseTableView;

/// Main split view that is the home to both the project list and the main view
@property (strong) IBOutlet CNSplitView *splitView;

/// Checkbox to indicate whether the expected response is in CSV format
@property (strong) IBOutlet NSButton *csvCheckBox;

/// Reference to MenuController
@property (strong, nonatomic) IBOutlet MenuController *menuController;

/// Reference to JsonViewerWindowController
@property (strong, nonatomic) JsonViewerWindowController *jsonWindow;

/// Reference to CsvViewerWindowController
@property (strong, nonatomic) CsvViewerWindowController *csvWindow;

/// Dictionary that holds a reference to the request headers.  This dictionary is used to populate the requestTableView.
@property (strong, nonatomic) NSDictionary *requestDict;

/// Dictionary that holds a reference to the response headers.  This dictionary is used to populate the responseTableView.
@property (strong, nonatomic) NSDictionary *responseDict;

/**
 * Fetch Action
 * @param sender The caller of this method
 */
-(IBAction)fetchAction:(id)sender;

/**
 * Action that adds or removes headers from the current URL object
 * @param sender The caller of this method
 */
-(IBAction)headerSegContAction:(id)sender;

/**
 * Action that adds or removes parameters from the current URL object
 * @param sender The caller of this method
 */
-(IBAction)parameterSegContAction:(id)sender;

/**
 * Action that shows or hides the customPayloadTextView
 * @param sender The caller of this method
 */
-(IBAction)customPostBodyAction:(id)sender;

/**
 * Action that clears the output in outputTextView
 * @param sender The caller of this method
 */
-(IBAction)clearOutput:(id)sender;

/**
 * Action that shows the JsonViewerWindowController window
 * @param sender The caller of this method
 */
-(IBAction)showJson:(id)sender;

/**
 * Test CSV using a file
 * @param sender The caller of this method
 */
-(IBAction)testCSV:(id)sender;

/**
 * Action to indicate whether the response of the fetch will be in CSV format
 * @param sender The caller of this method
 */
-(IBAction)responseIsCSVAction:(id)sender;

/**
 * Begins the process of exporting a project
 * @param sender The caller of this method
 */
-(void)exportProject:(id)sender;

/**
 * Begins the process of importing a project
 * @param sender The caller of this method
 */
-(void)importProject:(id)sender;

/**
 * Deletes current project
 * @param sender The caller of this method
 */
-(void)deleteProject:(id)sender;

/**
 * Adds url to current project
 * @param sender The caller of this method
 */
-(void)addUrl:(id)sender;

/**
 * Method that saves the output of outputTextView to a file
 */
-(void)saveLog;

@end
