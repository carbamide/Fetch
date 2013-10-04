//
//  ViewController.m
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "MainWindowController.h"
#import "Urls.h"
#import "NSUserDefaults+NSColor.h"
#import "Constants.h"
#import "Projects.h"
#import "Headers.h"
#import "Parameters.h"
#import "ProjectHandler.h"
#import "JsonViewerWindowController.h"
#import "ProjectCell.h"
#import "UrlCell.h"
#import "NSTimer+Blocks.h"

enum {
    SiteUp = 0,
    SiteDown,
    SiteInconclusive
};

typedef NSUInteger UrlStatus;

@interface MainWindowController ()
@property (strong, nonatomic) NSMutableArray *headerDataSource;
@property (strong, nonatomic) NSMutableArray *paramDataSource;
@property (strong, nonatomic) NSMutableArray *urlList;
@property (strong, nonatomic) NSMutableArray *projectList;
@property (strong, nonatomic) NSArray *headerNames;
@property (strong, nonatomic) Projects *currentProject;
@property (strong, nonatomic) Urls *currentUrl;
@property (strong, nonatomic) id jsonData;
@property (strong, nonatomic) CNSplitViewToolbar *toolbar;
@property (strong, nonatomic) CNSplitViewToolbarButton *removeButton;
@property (strong, nonatomic) CNSplitViewToolbarButton *exportButton;
@property (strong, nonatomic) NSMutableArray *urlCellArray;
@property (strong, nonatomic) NSTimer *pingTimer;

@end

static int const kProjectListSplitViewSide = 0;
static int const kMinimumSplitViewSize = 300;
static NSString *const kUTITypePublicFile = @"public.file-url";
@implementation MainWindowController

#pragma mark
#pragma mark Lifecycle

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    NSLog(@"%s", __FUNCTION__);
    
    self = [super initWithWindowNibName:windowNibName];
    
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

-(void)windowDidLoad
{
    NSLog(@"%s", __FUNCTION__);
    
    [super windowDidLoad];
    
    BOOL checkSiteReachability = [[NSUserDefaults standardUserDefaults] boolForKey:kPingForReachability];
    
    NSString *frequencyToPing = [[NSUserDefaults standardUserDefaults] stringForKey:kFrequencyToPing];
    
    if (checkSiteReachability) {
        [self createTimerWithTimeInterval:[frequencyToPing intValue]];
    }
    else {
        for (UrlCell *cell in [self urlCellArray]) {
            [[cell statusImage] setHidden:YES];
        }
    }
    
    [[self projectSourceList] registerForDraggedTypes:@[NSFilenamesPboardType, NSFilesPromisePboardType]];
    
    [[self menuController] setMainWindowController:self];
    
    [self setProjectList:[[[Projects all] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] mutableCopy]];
    
    [[self urlCellArray] removeAllObjects];
    
    [[self projectSourceList] reloadData];
    
    [self preferencesChanges:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChanges:) name:NSUserDefaultsDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUrlFromNotification:) name:@"ADD_URL" object:nil];
    
    [self setupSegmentedControls];
    
    [[self customPayloadTextView] setValue:@"Place custom payload text here..." forKey:@"placeholderString"];
    
    [[self methodCombo] selectItemAtIndex:GET_METHOD];
    
    [self setToolbar:[[CNSplitViewToolbar alloc] init]];
    
    NSMenu *contextMenu = [[NSMenu alloc] init];
    [contextMenu addItemWithTitle:@"Add New Project" action:@selector(addProject) keyEquivalent:@""];
    [contextMenu addItemWithTitle:@"Add New URL" action:@selector(addUrl:) keyEquivalent:@""];
    [contextMenu setDelegate:self];
    
    CNSplitViewToolbarButton *addButton = [[CNSplitViewToolbarButton alloc] initWithContextMenu:contextMenu];
    [addButton setImageTemplate:CNSplitViewToolbarButtonImageTemplateAdd];
    
    _removeButton = [[CNSplitViewToolbarButton alloc] init];
    [[self removeButton] setImageTemplate:CNSplitViewToolbarButtonImageTemplateRemove];
    [[self removeButton] setTarget:self];
    [[self removeButton] setAction:@selector(removeProjectOrUrl)];
    [[self removeButton] setEnabled:NO];
    
    _exportButton = [[CNSplitViewToolbarButton alloc] init];
    [[self exportButton] setImageTemplate:CNSplitViewToolbarButtonImageTemplateShare];
    [[self exportButton] setTarget:self];
    [[self exportButton] setAction:@selector(exportProject:)];
    [[self exportButton] setEnabled:NO];
    
    [[self toolbar] addItem:addButton align:CNSplitViewToolbarItemAlignLeft];
    [[self toolbar] addItem:[self removeButton] align:CNSplitViewToolbarItemAlignLeft];
    [[self toolbar] addItem:[self exportButton] align:CNSplitViewToolbarItemAlignRight];
    
    [[self splitView] setDelegate:self];
    [[self splitView] setToolbarDelegate:self];
    [[self splitView] attachToolbar:[self toolbar] toSubViewAtIndex:0 onEdge:CNSplitViewToolbarEdgeBottom];
    
    [[self splitView] showToolbarAnimated:NO];
    
    for (int index = 0; index < [[self projectList] count]; index++) {
        id item = [[self projectSourceList] itemAtRow:index];
        
        if ([item isKindOfClass:[Projects class]]) {
            
            BOOL shouldExpand = [[(Projects *)item expanded] boolValue];
            
            if (shouldExpand) {
                [[[self projectSourceList] animator] expandItem:item];
            }
        }
    }
}

-(void)awakeFromNib
{
    NSLog(@"%s", __FUNCTION__);
}

-(void)preferencesChanges:(NSNotification *)aNotification
{
    NSLog(@"%s", __FUNCTION__);
    
    NSColor *backgroundColor = [[NSUserDefaults standardUserDefaults] colorForKey:kBackgroundColor];
    NSColor *foregroundColor = [[NSUserDefaults standardUserDefaults] colorForKey:kForegroundColor];
    
    [[self outputTextView] setTextColor:foregroundColor];
    [[self outputTextView] setBackgroundColor:backgroundColor];
    
    BOOL checkSiteReachability = [[NSUserDefaults standardUserDefaults] boolForKey:kPingForReachability];
    
    NSString *frequencyToPing = [[NSUserDefaults standardUserDefaults] stringForKey:kFrequencyToPing];
    
    if (checkSiteReachability) {
        if ([_pingTimer isValid]) {
            [_pingTimer invalidate];
        }
        
        [self createTimerWithTimeInterval:[frequencyToPing intValue]];
        
        for (UrlCell *cell in [self urlCellArray]) {
            [[cell statusImage] setHidden:NO];
        }
    }
    else {
        [[self pingTimer] invalidate];
        
        for (UrlCell *cell in [self urlCellArray]) {
            [[cell statusImage] setHidden:YES];
        }
    }
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
        
        [tempUrl setCreatedAt:[NSDate date]];
        [tempUrl setMethod:[NSNumber numberWithInteger:[[self methodCombo] indexOfSelectedItem]]];
        [tempUrl setUrl:[[self urlTextField] stringValue]];
        
        [self setCurrentUrl:tempUrl];
        [[self exportButton] setEnabled:YES];
        [[self removeButton] setEnabled:YES];
        
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
    else {
        [[self urlDescriptionTextField] setStringValue:@""];
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
            
            [self setProjectList:[[[Projects all] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] mutableCopy]];
            
            [[self urlCellArray] removeAllObjects];
            
            [[self projectSourceList] reloadData];
        }
    }
}

-(void)exportProject:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    id selectedProject = nil;
    
    if ([sender isKindOfClass:[CNSplitViewToolbarButton class]]) {
        selectedProject = [[self projectSourceList] itemAtRow:[[self projectSourceList] selectedRow]];
    }
    else {
        selectedProject = [[self projectSourceList] itemAtRow:[[self projectSourceList] clickedRow]];
    }
    
    if ([selectedProject isKindOfClass:[Urls class]]) {
        selectedProject = [selectedProject project];
    }
    
    NSAssert(selectedProject, @"project cannot be nil in %s", __FUNCTION__);
    
    [savePanel setTitle:@"Export"];
    [savePanel setNameFieldStringValue:[[selectedProject name] stringByAppendingPathExtension:@"fetch"]];
    
    if ([savePanel runModal] == NSOKButton) {
        [ProjectHandler exportProject:selectedProject toUrl:[savePanel URL]];
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
            [[self exportButton] setEnabled:NO];
            [[self removeButton] setEnabled:NO];
            
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
    
    [[self urlCellArray] removeAllObjects];
    
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
    [[self exportButton] setEnabled:YES];
    [[self removeButton] setEnabled:YES];
    
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
        
        [tempUrl setCreatedAt:[NSDate date]];
        [tempUrl setUrlDescription:@"New URL"];
        
        [[self currentProject] addUrlsObject:tempUrl];
        
        [[self currentProject] save];
        
        [[self urlList] addObject:tempUrl];
        
        [[self urlCellArray] removeAllObjects];
        
        [[self projectSourceList] reloadData];
        
        [[self fetchButton] setEnabled:YES];
        [[self urlTextField] setEnabled:YES];
        [[self urlDescriptionTextField] setEnabled:YES];
        
        [[self projectSourceList] expandItem:[[self projectSourceList] itemAtRow:[[self projectSourceList] rowForItem:[tempUrl project]]]];
    }
}

-(void)addUrlFromNotification:(NSNotification *)aNotification
{
    Projects *tempProject = [aNotification userInfo][@"project"];
    
    Urls *tempUrl = [Urls create];
    
    [tempUrl setCreatedAt:[NSDate date]];
    [tempUrl setUrlDescription:@"New URL"];
    
    [tempProject addUrlsObject:tempUrl];
    [tempProject save];
    
    [[self urlList] addObject:tempUrl];
    
    [[self urlCellArray] removeAllObjects];
    
    [[self projectSourceList] reloadData];
    
    [[self fetchButton] setEnabled:YES];
    [[self urlTextField] setEnabled:YES];
    [[self urlDescriptionTextField] setEnabled:YES];
    
    [[self projectSourceList] expandItem:[[self projectSourceList] itemAtRow:[[self projectSourceList] rowForItem:[tempUrl project]]]];
}

-(void)saveLog
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    [savePanel setTitle:@"Save Log"];
    [savePanel setNameFieldStringValue:[@"LogFile" stringByAppendingPathExtension:@"txt"]];
    
    if ([savePanel runModal] == NSOKButton) {
        NSError *error = nil;
        
        [[[self outputTextView] string] writeToFile:[[savePanel URL] path] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSAlert *errorAlert = [NSAlert alertWithError:error];
            
            [errorAlert runModal];
        }
    }
}

-(void)addProject
{
    [self unloadData];
    
    [self setCurrentUrl:nil];
    
    [[self urlDescriptionTextField] setStringValue:@""];
    [[self urlTextField] setStringValue:@""];
    [[self urlDescriptionTextField] setEnabled:NO];
    [[self urlTextField] setEnabled:NO];
    [[self fetchButton] setEnabled:NO];
    
    [self setResponseDict:nil];
    [self setRequestDict:nil];
    
    Projects *tempProject = [Projects create];
    
    [tempProject setName:@"Project Name"];
    [tempProject save];
    
    [self setCurrentProject:tempProject];
    [[self exportButton] setEnabled:YES];
    [[self removeButton] setEnabled:YES];
    
    [[self projectList] addObject:tempProject];
    
    [[self urlCellArray] removeAllObjects];
    
    [[self projectSourceList] reloadData];
    
    [[self projectSourceList] selectRowIndexes:[NSIndexSet indexSetWithIndex:[[self projectSourceList] numberOfRows] - 1] byExtendingSelection:NO];
}

-(void)removeProjectOrUrl
{
    id item = [[self projectSourceList] itemAtRow:[[self projectSourceList] selectedRow]];
    
    if ([item isKindOfClass:[Projects class]]) {
        NSString *messageText = [NSString stringWithFormat:@"Delete project \"%@\"?  You cannot undo this action.", [item name]];
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Delete Project?" defaultButton:@"Delete" alternateButton:nil otherButton:@"Cancel" informativeTextWithFormat:messageText, nil];
        
        if ([alert runModal] == NSOKButton) {
            [[self projectList] removeObject:item];
            
            if (item == [self currentProject]) {
                [self setCurrentProject:nil];
                
                [[self exportButton] setEnabled:NO];
                [[self removeButton] setEnabled:NO];
                
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
    }
    else if ([item isKindOfClass:[Urls class]]) {
        NSString *messageText = @"Delete url? You cannot undo this action.";
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Delete URL?" defaultButton:@"Delete" alternateButton:nil otherButton:@"Cancel" informativeTextWithFormat:messageText, nil];
        
        if ([alert runModal] == NSOKButton) {
            [[self urlList] removeObject:item];
            
            [item delete];
            
            if (item == [self currentUrl]) {
                [[self jsonOutputButton] setEnabled:NO];
                [[self fetchButton] setEnabled:NO];
                
                [[self urlList] removeAllObjects];
                
                [[Urls all] each:^(Urls *object) {
                    if ([object url]) {
                        [[self urlList] addObject:[object url]];
                    }
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
    }

    [[self urlCellArray] removeAllObjects];
    
    [[self projectSourceList] reloadData];
}

#pragma mark
#pragma mark IBActions

-(IBAction)fetchAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableString *parameters = [[NSMutableString alloc] init];
    
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
        
        [[self fetchButton] setHidden:NO];
        [[self progressIndicator] stopAnimation:self];
        [[self progressIndicator] setHidden:YES];
        
        return;
    }
    
    if ([self addToUrlListIfUnique]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setHTTPMethod:[[self methodCombo] objectValueOfSelectedItem]];
        
        for (Headers *tempHeader in [self headerDataSource]) {
            [request setValue:[tempHeader value] forHTTPHeaderField:[tempHeader name]];
        }
        
        if ([[self customPostBodyCheckBox] state] == NSOnState) {
            [request setHTTPBody:[[[self customPayloadTextView] string] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else {
            for (Parameters *tempParam in [self paramDataSource]) {
                if (tempParam == [[self paramDataSource] first]) {
                    [parameters appendString:[NSString stringWithFormat:@"?%@=%@", [tempParam name], [tempParam value]]];
                }
                else {
                    [parameters appendString:[NSString stringWithFormat:@"&%@=%@", [tempParam name], [tempParam value]]];
                }
            }
        }
        
        if ([parameters length] > 0) {
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[self urlTextField] stringValue], parameters]]];
        }
        else {
            [request setURL:[NSURL URLWithString:[[self urlTextField] stringValue]]];
        }
        
        if ([[self logRequestCheckBox] state] == NSOnState) {
            [self logReqest:request];
        }
        
        [self setRequestDict:[request allHTTPHeaderFields]];
        
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
            
            [self setResponseDict:[urlResponse allHeaderFields]];
            
            if (!connectionError) {
                id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if (jsonData) {
                    NSData *jsonHolder = [NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:nil];
                    
                    if (jsonHolder) {
                        [self appendToOutput:[[NSString alloc] initWithData:jsonHolder encoding:NSUTF8StringEncoding] color:[userDefaults colorForKey:kForegroundColor]];
                    }
                    
                    [[self jsonOutputButton] setEnabled:YES];
                    [self setJsonData:jsonData];
                }
                else {
                    [self appendToOutput:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] color:[userDefaults colorForKey:kForegroundColor]];
                }
                
                if ([[[self jsonWindow] window] isVisible]) {
                    [self showJson:nil];
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
        
        [[self urlCellArray] removeAllObjects];
        
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
    else if ([[[notification object] superview] isKindOfClass:[ProjectCell class]]) {
        ProjectCell *tempCell = (ProjectCell *)[[notification object] superview];
        NSTextField *tempTextField = [notification object];
        Projects *project = [tempCell project];
        
        [project setName:[tempTextField stringValue]];
        [project save];
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
        Parameters *tempParam = [self paramDataSource][row];
        
        if ([identifier isEqualToString:kParameterName]) {
            return [tempParam name];
        }
        else {
            return [tempParam value];
        }
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
            
            if ([identifier isEqualToString:kParameterName]) {
                if (([[self paramDataSource] count] - 1) >= row) {
                    tempParam = [self paramDataSource][row];
                }
                else {
                    tempParam = [Parameters create];
                    
                    [[self currentUrl] addParametersObject:tempParam];
                }
                
                [tempParam setName:object];
                [tempParam save];
            }
            else {
                if (([[self paramDataSource] count] - 1) >= row) {
                    tempParam = [self paramDataSource][row];
                }
                else {
                    tempParam = [Parameters create];
                    
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
        
        NSArray *tempArray = [NSArray arrayWithArray:[[[tempProject urls] allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]]];
        
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

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item
{
    return YES;
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification;
{
    Projects *project = [[notification userInfo] valueForKey:@"NSObject"];
    
    [project setExpanded:@YES];
    [project save];
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
    Projects *project = [[notification userInfo] valueForKey:@"NSObject"];
    
    [project setExpanded:@NO];
    [project save];
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

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    static NSString *const CellIdentifier = @"DataCell";
    static NSString *const UrlCellIdentifier = @"UrlCell";
    
    if ([item isKindOfClass:[Projects class]]) {
        ProjectCell *cell = [outlineView makeViewWithIdentifier:CellIdentifier owner:self];
        
        Projects *tempProject = item;
        
        [[cell textField] setStringValue:[tempProject name]];
        [cell setProject:tempProject];
        
        [[cell addUrlButton] setHidden:NO];
        
        return cell;
    }
    else {
        if (![self urlCellArray]) {
            [self setUrlCellArray:[NSMutableArray array]];
        }
        
        UrlCell *cell = [outlineView makeViewWithIdentifier:UrlCellIdentifier owner:self];
        
        Urls *tempUrl = item;
        
        [cell setCurrentUrl:tempUrl];
        
        if ([[cell currentUrl] siteStatus]) {
            [[cell statusImage] setImage:[NSImage imageNamed:[tempUrl siteStatus]]];
        }
        
        if ([tempUrl urlDescription]) {
            [[cell textField] setStringValue:[tempUrl urlDescription]];
        }
        else {
            [[cell textField] setStringValue:[tempUrl url]];
        }
        
        [[self urlCellArray] addObject:cell];
        
        return cell;
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
    
    id selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    
    if ([selectedItem isKindOfClass:[Projects class]]) {
        Projects *tempProject = selectedItem;
        
        [self loadProject:tempProject];
    }
    else {
        Urls *tempItem = selectedItem;
        
        if ([self currentProject] != [tempItem project]) {
            [self loadProject:[selectedItem project]];
        }
        
        if ([tempItem url]) {
            [[self urlTextField] setStringValue:[tempItem url]];
        }
        else {
            [[self urlTextField] setStringValue:@""];
        }
        
        [self urlSelection:tempItem];
    }
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    return NSDragOperationCopy;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
{
    NSURL *draggedUrl = [NSURL URLWithString:[[info draggingPasteboard] stringForType:kUTITypePublicFile]];
    
    if ([ProjectHandler importFromPath:[draggedUrl path]]) {
        [[self projectList] removeAllObjects];
        
        [self setProjectList:[[[Projects all] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] mutableCopy]];
        
        [[self urlCellArray] removeAllObjects];
        
        [[self projectSourceList] reloadData];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return YES;
}

#pragma mark
#pragma mark NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu
{
    if ([self currentProject]) {
        [[menu itemAtIndex:1] setHidden:NO];
    }
    else {
        [[menu itemAtIndex:1] setHidden:YES];
    }
}

#pragma mark
#pragma mark CNSplitViewToolbarDelegate

- (NSUInteger)toolbarAttachedSubviewIndex:(CNSplitViewToolbar *)theToolbar
{
    return kProjectListSplitViewSide;
}

#pragma mark
#pragma mark NSSplitViewDelegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex
{
    return kMinimumSplitViewSize;
}

#pragma mark
#pragma mark UrlCell Delegate

-(void)createTimerWithTimeInterval:(NSTimeInterval)timeInterval
{
    _pingTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval block:^{
        
        for (UrlCell *cell in [self urlCellArray]) {
            if (![[[cell currentUrl] url] isEqualToString:@""]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    UrlStatus status = [self urlVerification:[[cell currentUrl] url]];
                    
                    if (status == SiteUp) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[cell statusImage] setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
                            
                            [[cell currentUrl] setSiteStatus:NSImageNameStatusAvailable];
                            [[cell currentUrl] save];
                        });
                    }
                    else if (status == SiteInconclusive) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[cell statusImage] setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
                            
                            [[cell currentUrl] setSiteStatus:NSImageNameStatusPartiallyAvailable];
                            [[cell currentUrl] save];
                        });
                    }
                    else if (status == SiteDown) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[cell statusImage] setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];
                            
                            [[cell currentUrl] setSiteStatus:NSImageNameStatusUnavailable];
                            [[cell currentUrl] save];
                        });
                    }
                });
            }
        }
    } repeats:YES];
}

-(UrlStatus)urlVerification:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSHTTPURLResponse *response = nil;
    
    if ([NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]) {
        if ([response statusCode] > 199 && [response statusCode] < 300) {
            return SiteUp;
        }
        else if ([response statusCode] > 499 && [response statusCode] < 600){
            return SiteInconclusive;
        }
        else {
            return SiteDown;
        }
    }
    
    return SiteDown;
}

@end
