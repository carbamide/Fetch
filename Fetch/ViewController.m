//
//  ViewController.m
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ViewController.h"
#import "Urls.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *headerDataSource;
@property (strong, nonatomic) NSMutableArray *paramDataSource;

@property (strong, nonatomic) NSArray *headerNames;
@property (strong, nonatomic) NSMutableArray *urlList;

@end

@implementation ViewController

static NSString *const kInsertValue = @"Insert Value";
static NSString *const kInsertName = @"Insert Name";
static NSString *const kValue = @"Value";
static NSString *const kHeaderName = @"Header Name";
static NSString *const kParameterName = @"Parameter Name";

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
    }
    return self;
}

-(void)awakeFromNib
{
    NSLog(@"%s", __FUNCTION__);
    
    [[Urls all] each:^(Urls *object) {
        [[self urlList] addObject:[object url]];
    }];
    
    [self setupSegmentedControls];
    
    [[self customPayloadTextView] setValue:@"Place custom payload text here..." forKey:@"placeholderString"];
    [[self methodCombo] selectItemAtIndex:GET_METHOD];
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

#pragma mark
#pragma mark IBActions

-(IBAction)fetchAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    Urls *tempUrl = [Urls create];
    
    [tempUrl setUrl:[[self urlTextField] stringValue]];
    [tempUrl save];
    
    [[Urls all] each:^(Urls *object) {
        [[self urlList] addObject:[object url]];
    }];
    
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
        [self appendToOutput:[request HTTPMethod] color:[NSColor greenColor]];
        [self appendToOutput:[NSString stringWithFormat:@"%@", [request allHTTPHeaderFields]] color:[NSColor greenColor]];
        [self appendToOutput:[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] color:[NSColor greenColor]];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                            NSData *data,
                                                                                                            NSError *connectionError) {
        
        if (NSLocationInRange([(NSHTTPURLResponse *)response statusCode], NSMakeRange(200, (299 - 200)))) {
            [self appendToOutput:[NSString stringWithFormat:@"Response - %li\n", (long)[(NSHTTPURLResponse *)response statusCode]] color:[NSColor greenColor]];
        }
        else {
            [self appendToOutput:[NSString stringWithFormat:@"Response - %li\n", (long)[(NSHTTPURLResponse *)response statusCode]] color:[NSColor redColor]];
        }
        
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
            
            NSLog(@"There was a connection error - %@", [connectionError localizedDescription]);
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
        
        [[self paramSegCont] setHidden:YES];
    }
    else {
        [[[self customPayloadTextView] enclosingScrollView] setHidden:YES];
        
        [[self paramSegCont] setHidden:NO];
    }
}

-(IBAction)clearOutput:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self outputTextView] setString:@""];
    
    [[self clearOutputButton] setEnabled:NO];
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
        
        [[self headerDataSource] replaceObjectAtIndex:row withObject:tempDict];
    }
    else {
        NSMutableDictionary *tempDict = [[self paramDataSource][row] mutableCopy];
        
        [tempDict setObject:object forKey:identifier];
        
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

@end
