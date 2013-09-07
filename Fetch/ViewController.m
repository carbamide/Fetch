//
//  ViewController.m
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ViewController.h"
#import "Urls.h"
#import "NSUserDefaults+NSColor.h"
#import "Constants.h"
#import "Projects.h"
#import "Headers.h"
#import "Parameters.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *headerDataSource;
@property (strong, nonatomic) NSMutableArray *paramDataSource;
@property (strong, nonatomic) NSMutableArray *urlList;
@property (strong, nonatomic) NSMutableArray *projectList;

@property (strong, nonatomic) NSArray *headerNames;

@property (strong, nonatomic) Projects *currentProject;

@end

@implementation ViewController

#pragma mark
#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (![self headerDataSource]) {
            [self setHeaderDataSource:[[NSMutableArray alloc] init]];
        }
        
        if (![self paramDataSource]) {
            [self setParamDataSource:[[NSMutableArray alloc] init]];
        }
        
        if (![self headerNames]) {
            [self setHeaderNames:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HeaderNames" ofType:@"plist"]]];
        }
        
        if (![self urlList]) {
            [self setUrlList:[NSMutableArray array]];
        }
        
        if (![self projectList]) {
            [self setProjectList:[NSMutableArray array]];
        }
    }
    return self;
}

-(void)awakeFromNib
{
    NSLog(@"%s", __FUNCTION__);
    
    [[Urls all] each:^(Urls *object) {
        [[self urlList] addObject:[object url]];
    }];
    
    [[Projects all] each:^(Projects *object) {
        [[self projectList] addObject:object];
    }];
    
    [self preferencesChanges:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChanges:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [self setupSegmentedControls];
    
    [[self customPayloadTextView] setValue:@"Place custom payload text here..." forKey:@"placeholderString"];
    
    [[self methodCombo] selectItemAtIndex:GET_METHOD];
}

-(void)preferencesChanges:(NSNotification *)aNotification
{
    NSColor *backgroundColor = [[NSUserDefaults standardUserDefaults] colorForKey:kBackgroundColor];
    NSColor *foregroundColor = [[NSUserDefaults standardUserDefaults] colorForKey:kForegroundColor];
    
    [[self outputTextView] setTextColor:foregroundColor];
    [[self outputTextView] setBackgroundColor:backgroundColor];
}

-(void)setupSegmentedControls
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([[self headerDataSource] count] == 0) {
        [[self headerSegCont] setEnabled:NO forSegment:1];
    }
    else {
        [[self headerSegCont] setEnabled:YES forSegment:1];
    }
    
    if ([[self paramDataSource] count] == 0) {
        [[self paramSegCont] setEnabled:NO forSegment:1];
    }
    else {
        [[self paramSegCont] setEnabled:YES forSegment:1];
    }
}

- (void)appendToOutput:(NSString *)text color:(NSColor *)color
{
    NSLog(@"%s", __FUNCTION__);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[text stringByAppendingString:@"\n"]];
        
        if (color) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
        }
        
        [[[self outputTextView] textStorage] appendAttributedString:attributedString];
        [[self outputTextView] scrollRangeToVisible:NSMakeRange([[[self outputTextView] string] length], 0)];
        
        [[self clearOutputButton] setEnabled:YES];
    });
}

-(void)addToUrlListIfUnique
{
    BOOL addURL = YES;
    
    for (NSString *tempURL in [self urlList]) {
        if ([tempURL isEqualToString:[[self urlTextField] stringValue]]) {
            addURL = NO;
        }
    }
    
    if (addURL) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setUrl:[[self urlTextField] stringValue]];
        
        if ([self currentProject]) {
            [[self currentProject] addUrlsObject:tempUrl];
            
            [[self currentProject] save];
            
            [[self urlList] removeAllObjects];
            
            for (Urls *url in [[self currentProject] urls]) {
                [[self urlList] addObject:[url url]];
            }
        }
        else {
            [tempUrl save];
            
            [[self urlList] removeAllObjects];
            
            [[Urls all] each:^(Urls *object) {
                [[self urlList] addObject:[object url]];
            }];
        }
    }
}

-(void)logReqest:(NSMutableURLRequest *)request
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self appendToOutput:kRequestSeparator color:[userDefaults colorForKey:kSeparatorColor]];
    
    [self appendToOutput:[request HTTPMethod] color:[userDefaults colorForKey:kSuccessColor]];
    [self appendToOutput:[NSString stringWithFormat:@"%@", [request allHTTPHeaderFields]] color:[userDefaults colorForKey:kSuccessColor]];
    [self appendToOutput:[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] color:[userDefaults colorForKey:kSuccessColor]];
}

-(void)showProjects
{
    if (![[self projectSegControl] isHidden]) {
        [[[self projectSourceList] enclosingScrollView] setHidden:YES];
        [[self projectSegControl] setHidden:YES];
        
        [[[self headersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.headersTableView.enclosingScrollView.frame.origin.x - 160, self.headersTableView.enclosingScrollView.frame.origin.y, self.headersTableView.enclosingScrollView.frame.size.width + 160, self.headersTableView.enclosingScrollView.frame.size.height))];
        
        [[[self parametersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.parametersTableView.enclosingScrollView.frame.origin.x - 160, self.parametersTableView.enclosingScrollView.frame.origin.y, self.parametersTableView.enclosingScrollView.frame.size.width + 160, self.parametersTableView.enclosingScrollView.frame.size.height))];
        
    }
    else {
        [[[self projectSourceList] enclosingScrollView] setHidden:NO];
        [[self projectSegControl] setHidden:NO];
        
        [[[self headersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.headersTableView.enclosingScrollView.frame.origin.x + 160, self.headersTableView.enclosingScrollView.frame.origin.y, self.headersTableView.enclosingScrollView.frame.size.width - 160, self.headersTableView.enclosingScrollView.frame.size.height))];
        
        [[[self parametersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.parametersTableView.enclosingScrollView.frame.origin.x + 160, self.parametersTableView.enclosingScrollView.frame.origin.y, self.parametersTableView.enclosingScrollView.frame.size.width - 160, self.parametersTableView.enclosingScrollView.frame.size.height))];
        
        [[self projectSourceList] reloadData];
    }
}

#pragma mark
#pragma mark IBActions

-(IBAction)fetchAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self addToUrlListIfUnique];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[self urlTextField] stringValue]]];
    
    [request setHTTPMethod:[[self methodCombo] objectValueOfSelectedItem]];
    
    for (NSDictionary *tempDict in [self headerDataSource]) {
        [request setValue:tempDict[kValue] forHTTPHeaderField:tempDict[kHeaderName]];
    }
    
    if ([[self customPostBodyCheckBox] state] == NSOnState) {
        [request setHTTPBody:[[[self customPayloadTextView] string] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        NSMutableString *postBody = [[NSMutableString alloc] init];
        
        for (NSDictionary *tempDict in [self paramDataSource]) {
            if (tempDict == [[self paramDataSource] firstObject]) {
                [postBody appendString:[NSString stringWithFormat:@"%@=%@", tempDict[kParameterName], tempDict[kValue]]];
            }
            else {
                [postBody appendString:[NSString stringWithFormat:@"&%@=%@", tempDict[kParameterName], tempDict[kValue]]];
            }
        }
        
        [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([[self logRequestCheckBox] state] == NSOnState) {
        [self logReqest:request];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                            NSData *data,
                                                                                                            NSError *connectionError) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [urlResponse statusCode];
        NSString *responseCodeString = [NSString stringWithFormat:@"Response - %li\n", responseCode];
        
        [self appendToOutput:kResponseSeparator color:[userDefaults colorForKey:kSeparatorColor]];
        
        if (NSLocationInRange(responseCode, NSMakeRange(200, (299 - 200)))) {
            [self appendToOutput:responseCodeString color:[userDefaults colorForKey:kSuccessColor]];
        }
        else {
            [self appendToOutput:responseCodeString color:[userDefaults colorForKey:kFailureColor]];
        }
        
        [self appendToOutput:[NSString stringWithFormat:@"%@", [urlResponse allHeaderFields]] color:[userDefaults colorForKey:kSuccessColor]];
        
        if (!connectionError) {
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (jsonData) {
                NSData *jsonHolder = [NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:nil];
                
                if (jsonHolder) {
                    [self appendToOutput:[[NSString alloc] initWithData:jsonHolder encoding:NSUTF8StringEncoding] color:nil];
                }
            }
            else {
                [self appendToOutput:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] color:nil];
            }
        }
        else {
            NSAlert *errorAlert = [NSAlert alertWithError:connectionError];
            
            [errorAlert runModal];
        }
    }];
}

-(IBAction)headerSegContAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSegmentedControl *tempSegCont = sender;
    
    if ([tempSegCont selectedSegment] == 0) {
        NSDictionary *tempDict = @{kHeaderName: @"Choose or insert header name", kValue: kInsertValue};
        
        [[self headerDataSource] addObject:tempDict];
        
        [[self headersTableView] beginUpdates];
        [[self headersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:([[self headerDataSource] count] - 1)] withAnimation:NSTableViewAnimationEffectFade];
        [[self headersTableView] endUpdates];
    }
    else {
        if ([[self headersTableView] selectedRow] == -1) {
            return;
        }
        
        if ([self currentProject]) {
            id tempDict = [self headerDataSource][[[self headersTableView] selectedRow]];
            
            Headers *tempHeader = [[Headers whereFormat:@"name == '%@' AND value == '%@'", tempDict[kHeaderName], tempDict[kValue]] first];
            
            [tempHeader delete];
        }

        [[self headerDataSource] removeObjectAtIndex:[[self headersTableView] selectedRow]];
        
        [[self headersTableView] reloadData];
    }
    
    [self setupSegmentedControls];
}

-(IBAction)parameterSegContAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSegmentedControl *tempSegCont = sender;
    
    if ([tempSegCont selectedSegment] == 0) {
        NSDictionary *tempDict = @{kParameterName: kInsertName, kValue: kInsertValue};
        
        [[self paramDataSource] addObject:tempDict];
        
        [[self parametersTableView] beginUpdates];
        [[self parametersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:[[self paramDataSource] count] - 1] withAnimation:NSTableViewAnimationEffectFade];
        [[self parametersTableView] endUpdates];
    }
    else {
        if ([[self parametersTableView] selectedRow] == -1) {
            return;
        }
        
        if ([self currentProject]) {
            id tempDict = [self paramDataSource][[[self parametersTableView] selectedRow]];
            
            Parameters *tempParameter = [[Parameters whereFormat:@"name == '%@' AND value == '%@'", tempDict[kParameterName], tempDict[kValue]] first];
            
            [tempParameter delete];
        }
        
        [[self paramDataSource] removeObjectAtIndex:[[self parametersTableView] selectedRow]];
        
        [[self parametersTableView] reloadData];
    }
    
    [self setupSegmentedControls];
}

-(IBAction)projectSegContAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSegmentedControl *tempSegCont = sender;
    
    if ([tempSegCont selectedSegment] == 0) {
        Projects *tempProject = [Projects create];
        
        [tempProject setName:@"Project Name"];
        [tempProject save];
        
        [self setCurrentProject:tempProject];
        
        [[self projectList] addObject:tempProject];
        
        [[self projectSourceList] reloadData];
    }
    else {
        Projects *tempProject = [self projectList][[[self projectSourceList] selectedRow]];
        
        if (tempProject == [self currentProject]) {
            [self setCurrentProject:nil];
        }
        
        [tempProject delete];
        
        
        [[self projectSourceList] reloadData];
    }
}

-(IBAction)customPostBodyAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([[self customPostBodyCheckBox] state] == NSOnState) {
        [[[self customPayloadTextView] enclosingScrollView] setHidden:NO];
        
        [[[self paramSegCont] animator] setAlphaValue:0.0];
        [[self paramSegCont] setEnabled:NO];
    }
    else {
        [[[self customPayloadTextView] enclosingScrollView] setHidden:YES];
        
        [[self paramSegCont] setEnabled:YES];
        [[[self paramSegCont] animator] setAlphaValue:1.0];
    }
}

-(IBAction)clearOutput:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self outputTextView] setString:@""];
    
    [[self clearOutputButton] setEnabled:NO];
}

-(IBAction)projectTableViewAction:(id)sender
{
    [[self headerDataSource] removeAllObjects];
    [[self headersTableView] reloadData];
    
    [[self paramDataSource] removeAllObjects];
    [[self parametersTableView] reloadData];
    
    [[self urlList] removeAllObjects];

    [[self urlTextField] setStringValue:@""];
    
    Projects *tempProject = [self projectList][[[self projectSourceList] clickedRow]];
    
    [self setCurrentProject:tempProject];
    
    [[self headersTableView] beginUpdates];
    
    int index = 0;
    
    for (Headers *tempHeader in [tempProject headers]) {
        [[self headerDataSource] addObject:@{kHeaderName: [tempHeader name], kValue: [tempHeader value]}];
        
        [[self headersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
        
        index++;
    }
    
    [[self headersTableView] endUpdates];
    
    index = 0;
    
    [[self parametersTableView] beginUpdates];
    
    for (Parameters *tempParam in [tempProject parameters]) {
        [[self paramDataSource] addObject:@{kParameterName: [tempParam name], kValue: [tempParam value]}];
        
        [[self parametersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
        
        index++;
    }
    
    [[self parametersTableView] endUpdates];
    
    for (Urls *url in [tempProject urls]) {
        [[self urlList] addObject:[url url]];
    }
    
    [self setupSegmentedControls];
}

#pragma mark
#pragma mark NSControlTextDelegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    if ([notification object] == [self urlTextField]) {
        if ([[[self urlTextField] stringValue] length] > 0) {
            [[self fetchButton] setEnabled:YES];
        }
        else {
            [[self fetchButton] setEnabled:NO];
        }
    }
}

-(void)controlTextDidEndEditing:(NSNotification *)notification
{
    if ([notification object] == [self urlTextField]) {
        if ([[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement) {
            [self fetchAction:nil];
        }
    }
}

#pragma mark
#pragma mark NSTableViewDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == [self headersTableView]) {
        return [[self headerDataSource] count];
    }
    else {
        return [[self paramDataSource] count];
    }
}

#pragma mark
#pragma mark NSTableViewDelegate

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    
    if (tableView == [self headersTableView]) {
        NSDictionary *tempDict = [self headerDataSource][row];
        
        return tempDict[identifier];
    }
    else {
        NSDictionary *tempDict = [self paramDataSource][row];
        
        return tempDict[identifier];
    }
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    
    if (tableView == [self headersTableView]) {
        NSMutableDictionary *tempDict = [[self headerDataSource][row] mutableCopy];
        
        [tempDict setObject:object forKey:identifier];
        
        if ([self currentProject]) {
            if (![tempDict[kValue] isEqualToString:kInsertValue]) {
                Headers *tempHeader = [Headers create];
                
                [tempHeader setName:tempDict[kHeaderName]];
                [tempHeader setValue:tempDict[kValue]];
                
                [[self currentProject] addHeadersObject:tempHeader];
                
                [[self currentProject] save];
            }
        }
        
        [[self headerDataSource] replaceObjectAtIndex:row withObject:tempDict];
    }
    else {
        NSMutableDictionary *tempDict = [[self paramDataSource][row] mutableCopy];
        
        [tempDict setObject:object forKey:identifier];
        
        if ([self currentProject]) {
            if (![tempDict[kValue] isEqualToString:kInsertValue]) {
                Parameters *tempParam = [Parameters create];
                
                [tempParam setName:tempDict[kParameterName]];
                [tempParam setValue:tempDict[kValue]];
                
                [[self currentProject] addParametersObject:tempParam];
                
                [[self currentProject] save];
            }
        }
        
        [[self paramDataSource] replaceObjectAtIndex:row withObject:tempDict];
    }
}

#pragma mark
#pragma mark NSComboBoxDataSource

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [[self urlList] count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return [self urlList][index];
}

#pragma mark
#pragma mark NSComboBoxDelegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    [[self fetchButton] setEnabled:YES];
}

#pragma mark
#pragma mark NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [[self projectList] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self projectList] count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    Projects *tempProject = item;
    
    return [tempProject name];
}

#pragma mark
#pragma mark NSOutlineViewDelegate

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    Projects *tempProject = item;
    
    [tempProject setName:object];
    
    [tempProject save];
}

@end
