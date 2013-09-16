//
//  ViewController.m
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "MainViewController.h"
#import "Urls.h"
#import "NSUserDefaults+NSColor.h"
#import "Constants.h"
#import "Projects.h"
#import "Headers.h"
#import "Parameters.h"
#import "ProjectHandler.h"
#import "JsonViewerWindowController.h"

@interface MainViewController ()
@property (strong, nonatomic) NSMutableArray *headerDataSource;
@property (strong, nonatomic) NSMutableArray *paramDataSource;
@property (strong, nonatomic) NSMutableArray *urlList;
@property (strong, nonatomic) NSMutableArray *projectList;

@property (strong, nonatomic) NSArray *headerNames;

@property (strong, nonatomic) Projects *currentProject;
@property (strong, nonatomic) Urls *currentUrl;

@property (strong, nonatomic) id jsonData;

@end

@implementation MainViewController

#pragma mark
#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"%s", __FUNCTION__);
    
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
        if ([object url]) {
            [[self urlList] addObject:[object url]];
        }
    }];
    
    __block BOOL showProject = NO;
    
    [[Projects all] each:^(Projects *object) {
        [[self projectList] addObject:object];
        
        showProject = YES;
    }];
    
    if (showProject) {
        [self showProjects];
    }
    
    [self preferencesChanges:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChanges:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [self setupSegmentedControls];
    
    [[self customPayloadTextView] setValue:@"Place custom payload text here..." forKey:@"placeholderString"];
    
    [[self methodCombo] selectItemAtIndex:GET_METHOD];
}

-(void)preferencesChanges:(NSNotification *)aNotification
{
    NSLog(@"%s", __FUNCTION__);
    
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

-(BOOL)addToUrlListIfUnique
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([[self urlTextField] stringValue] == nil || [[[self urlTextField] stringValue] isEqualToString:@""]) {
        return NO;
    }
    
    BOOL validPrefix = NO;
    
    NSArray *validUrlPrefixes = @[@"http", @"https"];
    
    for (NSString *prefix in validUrlPrefixes) {
        if ([[[self urlTextField] stringValue] hasPrefix:prefix]) {
            validPrefix = YES;
        }
    }
    
    if (!validPrefix) {
        NSAlert *errorAlert = [NSAlert alertWithMessageText:@"Invalid URL"
                                              defaultButton:@"OK"
                                            alternateButton:nil
                                                otherButton:nil
                                  informativeTextWithFormat:@"The url must be prefixed with the URL type.  Valid types are http and https"];
        
        [errorAlert runModal];
        
        return NO;
    }
    
    BOOL addURL = YES;
    
    for (Urls *tempURL in [self urlList]) {
        if ([[tempURL url] isEqualToString:[[self urlTextField] stringValue]]) {
            addURL = NO;
            
            break;
        }
    }
    
    if (addURL) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setMethod:[NSNumber numberWithInteger:[[self methodCombo] indexOfSelectedItem]]];
        [tempUrl setUrl:[[self urlTextField] stringValue]];
        
        [self setCurrentUrl:tempUrl];
        
        if ([self currentProject]) {
            [[self currentProject] addUrlsObject:tempUrl];
            
            [[self currentProject] save];
        }
        else {
            [tempUrl save];
        }
        
        [[self urlList] removeAllObjects];
        
        for (Urls *url in [[self currentProject] urls]) {
            [[self urlList] addObject:url];
        }
    }
    
    return YES;
}

-(void)logReqest:(NSMutableURLRequest *)request
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self appendToOutput:kRequestSeparator color:[userDefaults colorForKey:kSeparatorColor]];
    
    [self appendToOutput:[request HTTPMethod] color:[userDefaults colorForKey:kSuccessColor]];
    [self appendToOutput:[NSString stringWithFormat:@"%@", [request allHTTPHeaderFields]] color:[userDefaults colorForKey:kSuccessColor]];
    [self appendToOutput:[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] color:[userDefaults colorForKey:kSuccessColor]];
}

-(void)showProjects
{
    NSLog(@"%s", __FUNCTION__);
    
    if (![[self projectSegControl] isHidden]) {
        [[[self projectSourceList] enclosingScrollView] setHidden:YES];
        [[self projectSegControl] setHidden:YES];
        
        [[[self headersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.headersTableView.enclosingScrollView.frame.origin.x - 160, self.headersTableView.enclosingScrollView.frame.origin.y, self.headersTableView.enclosingScrollView.frame.size.width + 160, self.headersTableView.enclosingScrollView.frame.size.height))];
        
        [[[self parametersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.parametersTableView.enclosingScrollView.frame.origin.x - 160, self.parametersTableView.enclosingScrollView.frame.origin.y, self.parametersTableView.enclosingScrollView.frame.size.width + 160, self.parametersTableView.enclosingScrollView.frame.size.height))];
        
        [[[self customPayloadTextView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.customPayloadTextView.enclosingScrollView.frame.origin.x - 160, self.customPayloadTextView.enclosingScrollView.frame.origin.y, self.customPayloadTextView.enclosingScrollView.frame.size.width + 160, self.customPayloadTextView.enclosingScrollView.frame.size.height))];
        
    }
    else {
        [[[self projectSourceList] enclosingScrollView] setHidden:NO];
        [[self projectSegControl] setHidden:NO];
        
        [[[self headersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.headersTableView.enclosingScrollView.frame.origin.x + 160, self.headersTableView.enclosingScrollView.frame.origin.y, self.headersTableView.enclosingScrollView.frame.size.width - 160, self.headersTableView.enclosingScrollView.frame.size.height))];
        
        [[[self parametersTableView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.parametersTableView.enclosingScrollView.frame.origin.x + 160, self.parametersTableView.enclosingScrollView.frame.origin.y, self.parametersTableView.enclosingScrollView.frame.size.width - 160, self.parametersTableView.enclosingScrollView.frame.size.height))];
        
        [[[self customPayloadTextView] enclosingScrollView] setFrame:NSRectFromCGRect(CGRectMake(self.customPayloadTextView.enclosingScrollView.frame.origin.x + 160, self.customPayloadTextView.enclosingScrollView.frame.origin.y, self.customPayloadTextView.enclosingScrollView.frame.size.width - 160, self.customPayloadTextView.enclosingScrollView.frame.size.height))];
        
        [[self projectSourceList] reloadData];
    }
}

-(void)urlSelection:(Urls *)url
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self fetchButton] setEnabled:YES];
    
    Urls *tempUrl = url;
    
    [self setCurrentUrl:tempUrl];
    
    [[self methodCombo] selectItemAtIndex:[[tempUrl method] intValue]];
    
    if ([tempUrl customPayload] && [[tempUrl customPayload] length] > 0) {
        [[self customPayloadTextView] setString:[tempUrl customPayload]];
    }
    else {
        [[self customPayloadTextView] setString:@""];
    }
    
    if ([tempUrl urlDescription]) {
        [[self urlDescriptionTextField] setStringValue:[tempUrl urlDescription]];
    }
    
    [[self methodCombo] selectItemAtIndex:[[tempUrl method] integerValue]];
    
    int index = 0;
    
    [[self headerDataSource] removeAllObjects];
    [[self headersTableView] reloadData];
    
    if ([[tempUrl headers] count] > 0) {
        [[self headersTableView] beginUpdates];
        
        
        for (Headers *tempHeader in [tempUrl headers]) {
            [[self headerDataSource] addObject:tempHeader];
            
            [[self headersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
            
            index++;
        }
        
        [[self headersTableView] endUpdates];
    }
    
    [[self paramDataSource] removeAllObjects];
    [[self parametersTableView] reloadData];
    
    if ([[tempUrl parameters] count] > 0) {
        index = 0;
        
        [[self parametersTableView] beginUpdates];
        
        for (Parameters *tempParam in [tempUrl parameters]) {
            [[self paramDataSource] addObject:tempParam];
            
            [[self parametersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
            
            index++;
        }
        
        [[self parametersTableView] endUpdates];
    }
    
    if ([tempUrl customPayload] && [[tempUrl customPayload] length] > 0) {
        [[self customPostBodyCheckBox] setState:NSOnState];
        
        [[[self customPayloadTextView] enclosingScrollView] setHidden:NO];
        
        [[[self paramSegCont] animator] setAlphaValue:0.0];
        [[self paramSegCont] setEnabled:NO];
    }
    else {
        [[self customPostBodyCheckBox] setState:NSOffState];
        
        [[[self customPayloadTextView] enclosingScrollView] setHidden:YES];
        
        [[self paramSegCont] setEnabled:YES];
        [[[self paramSegCont] animator] setAlphaValue:1.0];
    }
}


-(void)importProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel setTitle:@"Import"];
    [openPanel setAllowedFileTypes:@[@"fetch"]];
    [openPanel setAllowsMultipleSelection:NO];
    
    if ([openPanel runModal] == NSOKButton) {
        if ([ProjectHandler importFromPath:[[openPanel URL] path]]) {
            [[self projectList] removeAllObjects];
            
            [[Projects all] each:^(Projects *object) {
                [[self projectList] addObject:object];
            }];
            
            [[self projectSourceList] reloadData];
        }
    }
}

-(void)exportProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    Projects *project = [self projectList][[[self projectSourceList] clickedRow]];
    
    [savePanel setTitle:@"Export"];
    [savePanel setNameFieldStringValue:[[project name] stringByAppendingPathExtension:@"fetch"]];
    
    if ([savePanel runModal] == NSOKButton) {
        [ProjectHandler exportProject:project toUrl:[savePanel URL]];
    }
}

-(void)deleteProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    id item = [[self projectSourceList] itemAtRow:[[self projectSourceList] clickedRow]];
    
    if ([item isKindOfClass:[Projects class]]) {
        Projects *tempProject = item;
        
        [[self projectList] removeObject:tempProject];
        
        if (tempProject == [self currentProject]) {
            [self setCurrentProject:nil];
            
            [self unloadData];
        }
        
        [tempProject delete];
    }
    else {
        Urls *tempUrl = item;
        
        [[self urlList] removeObject:tempUrl];
        
        if (tempUrl == [self currentUrl]) {
            [self setCurrentUrl:nil];
            
            [self unloadData];
        }
        
        [tempUrl delete];
    }
    
    
    [[self projectSourceList] reloadData];
}

-(void)unloadData
{
    [[self jsonOutputButton] setEnabled:NO];
    [[self fetchButton] setEnabled:NO];
    [[self urlTextField] setEnabled:NO];
    [[self urlDescriptionTextField] setEnabled:NO];
    
    [[self urlList] removeAllObjects];
    [[self headerDataSource] removeAllObjects];
    [[self paramDataSource] removeAllObjects];
    
    [[self headersTableView] reloadData];
    [[self parametersTableView] reloadData];
}

-(void)loadProject:(Projects *)project
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self headerDataSource] removeAllObjects];
    [[self headersTableView] reloadData];
    
    [[self paramDataSource] removeAllObjects];
    [[self parametersTableView] reloadData];
    
    [[self methodCombo] selectItemAtIndex:GET_METHOD];
    
    [[self urlList] removeAllObjects];
    
    [[self urlTextField] setStringValue:@""];
    [[self urlDescriptionTextField] setStringValue:@""];
    
    [[self customPayloadTextView] setString:@""];
    [[self customPostBodyCheckBox] setState:NSOffState];
    
    [self setCurrentProject:project];
    
    [[self fetchButton] setEnabled:YES];
    [[self urlTextField] setEnabled:YES];
    [[self urlDescriptionTextField] setEnabled:YES];
    [[self methodCombo] setEnabled:YES];
    
    for (Urls *url in [project urls]) {
        [[self urlList] addObject:url];
    }
    
    [self setupSegmentedControls];
}

-(void)addUrl:(id)sender
{
    if ([self currentProject]) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setUrlDescription:@"New URL"];
        
        [[self currentProject] addUrlsObject:tempUrl];
        
        [[self currentProject] save];
        
        [[self urlList] addObject:tempUrl];
        [[self projectSourceList] reloadData];
    }
}
#pragma mark
#pragma mark IBActions

-(IBAction)fetchAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self fetchButton] setHidden:YES];
    [[self progressIndicator] setHidden:NO];
    [[self progressIndicator] startAnimation:self];
    
    if ([[[self urlTextField] stringValue] isEqualToString:@""] || ![[self urlTextField] stringValue]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Unable to Fetch."];
        [alert setInformativeText:@"You must specify a URL."];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        [alert runModal];
        
        return;
    }
    
    if ([self addToUrlListIfUnique]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[self urlTextField] stringValue]]];
        
        [request setHTTPMethod:[[self methodCombo] objectValueOfSelectedItem]];
        
        for (Headers *tempHeader in [self headerDataSource]) {
            [request setValue:[tempHeader value] forHTTPHeaderField:[tempHeader name]];
        }
        
        if ([[self customPostBodyCheckBox] state] == NSOnState) {
            [request setHTTPBody:[[[self customPayloadTextView] string] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else {
            NSMutableString *postBody = [[NSMutableString alloc] init];
            
            for (NSDictionary *tempDict in [self paramDataSource]) {
                if (tempDict == [[self paramDataSource] first]) {
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
                    
                    [[self jsonOutputButton] setEnabled:YES];
                    [self setJsonData:jsonData];
                }
                else {
                    [self appendToOutput:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] color:nil];
                }
            }
            else {
                NSAlert *errorAlert = [NSAlert alertWithError:connectionError];
                
                [errorAlert runModal];
            }
            
            [[self fetchButton] setHidden:NO];
            [[self progressIndicator] stopAnimation:self];
            [[self progressIndicator] setHidden:YES];
        }];
        
        [[self projectSourceList] reloadData];
    }
}

-(IBAction)headerSegContAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSegmentedControl *tempSegCont = sender;
    
    if ([tempSegCont selectedSegment] == 0) {
        Headers *tempHeader = [Headers create];
        
        [tempHeader setName:@"Choose or insert header name"];
        [tempHeader setValue:kInsertValue];
        
        [tempHeader save];
        
        [[self currentUrl] addHeadersObject:tempHeader];
        
        [[self headerDataSource] addObject:tempHeader];
        
        [[self headersTableView] beginUpdates];
        [[self headersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:([[self headerDataSource] count] - 1)] withAnimation:NSTableViewAnimationEffectFade];
        [[self headersTableView] endUpdates];
    }
    else {
        if ([[self headersTableView] selectedRow] == -1) {
            return;
        }
        
        if ([self currentProject]) {
            Headers *tempHeader = [self headerDataSource][[[self headersTableView] selectedRow]];
            
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
        Parameters *tempParam = [Parameters create];
        
        [tempParam setName:kInsertName];
        [tempParam setValue:kInsertValue];
        
        [tempParam save];
        
        [[self currentUrl] addParametersObject:tempParam];
        
        [[self paramDataSource] addObject:tempParam];
        
        [[self parametersTableView] beginUpdates];
        [[self parametersTableView] insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:([[self paramDataSource] count] - 1)] withAnimation:NSTableViewAnimationEffectFade];
        [[self parametersTableView] endUpdates];
    }
    else {
        if ([[self parametersTableView] selectedRow] == -1) {
            return;
        }
        
        if ([self currentProject]) {
            Parameters *tempParam = [self paramDataSource][[[self parametersTableView] selectedRow]];
            
            [tempParam delete];
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
        
        [[self fetchButton] setEnabled:YES];
        [[self urlTextField] setEnabled:YES];
        [[self urlDescriptionTextField] setEnabled:YES];
        
        [[self projectList] addObject:tempProject];
        
        [[self projectSourceList] reloadData];
    }
    else {
        id item = [[self projectSourceList] itemAtRow:[[self projectSourceList] selectedRow]];
        
        if ([item isKindOfClass:[Projects class]]) {
            [[self projectList] removeObject:item];
            
            if (item == [self currentProject]) {
                [self setCurrentProject:nil];
                
                [[self jsonOutputButton] setEnabled:NO];
                [[self fetchButton] setEnabled:NO];
                [[self urlTextField] setEnabled:NO];
                [[self urlDescriptionTextField] setEnabled:NO];
                
                [[self urlList] removeAllObjects];
                [[self headerDataSource] removeAllObjects];
                [[self paramDataSource] removeAllObjects];
                
                [[self headersTableView] reloadData];
                [[self parametersTableView] reloadData];
            }
            
            [item delete];
        }
        else if ([item isKindOfClass:[Urls class]]) {
            [[self urlList] removeObject:item];
            
            [item delete];
            
            if (item == [self currentUrl]) {
                [[self jsonOutputButton] setEnabled:NO];
                [[self fetchButton] setEnabled:NO];
                
                [[self urlList] removeAllObjects];
                
                [[Urls all] each:^(Urls *object) {
                    [[self urlList] addObject:[object url]];
                }];
                
                [[self urlTextField] setStringValue:@""];
                [[self urlDescriptionTextField] setStringValue:@""];
                
                [[self methodCombo] setEnabled:NO];
                
                [[self headerDataSource] removeAllObjects];
                [[self paramDataSource] removeAllObjects];
                
                [[self headersTableView] reloadData];
                [[self parametersTableView] reloadData];
            }
        }
        
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

-(IBAction)showJson:(id)sender
{
    if (![self jsonWindow]) {
        [self setJsonWindow:[[JsonViewerWindowController alloc] initWithWindowNibName:@"JsonViewerWindowController" json:[self jsonData]]];
    }
    else {
        [[self jsonWindow] setJsonData:[self jsonData]];
        [[[self jsonWindow] outlineView] reloadData];
    }
    
    [[[self jsonWindow] window] makeKeyAndOrderFront:self];
}

#pragma mark
#pragma mark NSControlTextDelegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    if ([notification object] == [self urlTextField]) {
        if ([[[self urlTextField] stringValue] length] > 0) {
            if ([self currentUrl]) {
                [[self currentUrl] setUrl:[[self urlTextField] stringValue]];
                [[self currentUrl] save];
            }
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
    else if ([notification object] == [self urlDescriptionTextField]) {
        if ([self currentUrl]) {
            [[self currentUrl] setUrlDescription:[[self urlDescriptionTextField] stringValue]];
            
            [[self currentUrl] save];
        }
    }
    else if ([notification object] == [self customPayloadTextView]) {
        Urls *tempUrl = [self currentUrl];
        
        if (tempUrl) {
            if ([[self customPostBodyCheckBox] state] == NSOnState) {
                [tempUrl setCustomPayload:[[self customPayloadTextView] string]];
                
                [tempUrl save];
            }
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
        Headers *tempHeader = [self headerDataSource][row];
        
        if ([identifier isEqualToString:kHeaderName]) {
            return [tempHeader name];
        }
        else {
            return [tempHeader value];
        }
    }
    else {
        NSDictionary *tempDict = [self paramDataSource][row];
        
        return tempDict[identifier];
    }
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    
    if ([self currentProject]) {
        [self addToUrlListIfUnique];
        
        if (tableView == [self headersTableView]) {
            Headers *tempHeader = nil;
            
            if ([identifier isEqualToString:kHeaderName]) {
                if (([[self headerDataSource] count] - 1) >= row) {
                    tempHeader = [self headerDataSource][row];
                }
                else {
                    tempHeader = [Headers create];
                    
                    [[self currentUrl] addHeadersObject:tempHeader];
                }
                
                [tempHeader setName:object];
                [tempHeader save];
            }
            else {
                if (([[self headerDataSource] count] - 1) >= row) {
                    tempHeader = [self headerDataSource][row];
                }
                else {
                    tempHeader = [Headers create];
                    
                    [[self currentUrl] addHeadersObject:tempHeader];
                }
                
                [tempHeader setValue:object];
                [tempHeader save];
            }
            
            [[self headerDataSource] replaceObjectAtIndex:row withObject:tempHeader];
        }
        else {
            Parameters *tempParam = nil;
            
            if ([identifier isEqualToString:kHeaderName]) {
                if (([[self headerDataSource] count] - 1) >= row) {
                    tempParam = [self paramDataSource][row];
                }
                else {
                    tempParam = [Headers create];
                    
                    [[self currentUrl] addParametersObject:tempParam];
                }
                
                [tempParam setName:object];
                [tempParam save];
            }
            else {
                if (([[self headerDataSource] count] - 1) >= row) {
                    tempParam = [self paramDataSource][row];
                }
                else {
                    tempParam = [Headers create];
                    
                    [[self currentUrl] addParametersObject:tempParam];
                }
                
                [tempParam setValue:object];
                [tempParam save];
            }
            
            [[self paramDataSource] replaceObjectAtIndex:row withObject:tempParam];
        }
    }
}


#pragma mark
#pragma mark NSComboBoxDelegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    if ([notification object] == [self methodCombo]) {
        if ([self currentUrl]) {
            [self addToUrlListIfUnique];
            
            [[self currentUrl] setMethod:[NSNumber numberWithInteger:[[self methodCombo] indexOfSelectedItem]]];
            [[self currentUrl] save];
        }
    }
}

#pragma mark
#pragma mark NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (!item) {
        return [[self projectList] objectAtIndex:index];
    }
    else {
        Projects *tempProject = item;
        
        NSArray *tempArray = [NSArray arrayWithArray:[[tempProject urls] allObjects]];
        
        return tempArray[index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[Projects class]]) {
        Projects *tempProject = item;
        
        if ([[tempProject urls] count] > 0) {
            return YES;
        }
    }
    
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (!item) {
        return [[self projectList] count];
    }
    else {
        if ([item isKindOfClass:[Projects class]]) {
            Projects *tempProject = item;
            
            return [[tempProject urls] count];
        }
    }
    
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item isKindOfClass:[Projects class]]) {
        Projects *tempProject = item;
        
        return [tempProject name];
    }
    else {
        Urls *tempUrl = item;
        
        if ([tempUrl urlDescription]) {
            return [tempUrl urlDescription];
        }
        else {
            return [tempUrl url];
        }
    }
}

#pragma mark
#pragma mark NSOutlineViewDelegate

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    Projects *tempProject = item;
    
    [tempProject setName:object];
    
    [tempProject save];
}

-(void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSOutlineView *outlineView = [notification object];
    
    NSInteger selectedRow = [[outlineView selectedRowIndexes] firstIndex];
    
    id item = [outlineView itemAtRow:selectedRow];
    
    if ([item isKindOfClass:[Projects class]]) {
        Projects *tempProject = [self projectList][selectedRow];
        
        [self loadProject:tempProject];
    }
    else
    {
        Urls *tempItem = item;
        
        if ([self currentProject] != [tempItem project]) {
            [self loadProject:[item project]];
        }
        
        [[self urlTextField] setStringValue:[tempItem url]];

        [self urlSelection:tempItem];
    }
}

#pragma mark
#pragma mark NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu
{
    id item = [[self projectSourceList] itemAtRow:[[self projectSourceList] clickedRow]];
    
    if ([item isKindOfClass:[Projects class]]) {
        [[menu itemAtIndex:0] setHidden:NO];
        [[menu itemAtIndex:1] setHidden:NO];
        [[menu itemAtIndex:2] setTitle:@"Delete Project"];
        [[menu itemAtIndex:3] setHidden:NO];
        [[menu itemAtIndex:4] setHidden:NO];
    }
    else {
        [[menu itemAtIndex:0] setHidden:YES];
        [[menu itemAtIndex:1] setHidden:YES];
        [[menu itemAtIndex:2] setTitle:@"Delete URL"];
        [[menu itemAtIndex:3] setHidden:YES];
        [[menu itemAtIndex:4] setHidden:YES];
    }
}

@end
