//
//  ViewController.h
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

enum {
    GET_METHOD = 0,
    POST_METHOD = 1,
    PUT_METHOD = 2,
    DELETE_METHOD = 3
};
typedef NSUInteger HttpMethod;

@interface ViewController : NSViewController <NSControlTextEditingDelegate, NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDataSource, NSComboBoxDelegate>

@property (weak) IBOutlet NSComboBox *urlTextField;
@property (weak) IBOutlet NSComboBox *methodCombo;
@property (weak) IBOutlet NSButton *fetchButton;
@property (weak) IBOutlet NSButton *customPostBodyCheckBox;
@property (weak) IBOutlet NSButton *logRequestCheckBox;
@property (weak) IBOutlet NSButton *clearOutputButton;
@property (weak) IBOutlet NSTableView *headersTableView;
@property (weak) IBOutlet NSTableView *parametersTableView;
@property (weak) IBOutlet NSSegmentedControl *headerSegCont;
@property (weak) IBOutlet NSSegmentedControl *paramSegCont;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (unsafe_unretained) IBOutlet NSTextView *customPayloadTextView;

-(IBAction)fetchAction:(id)sender;
-(IBAction)headerSegContAction:(id)sender;
-(IBAction)parameterSegContAction:(id)sender;
-(IBAction)customPostBodyAction:(id)sender;
-(IBAction)clearOutput:(id)sender;

@end
