//
//  ViewController.m
//  Fetch
//
//  Created by Joshua Barrow on 9/3/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *headerDataSource;
@property (strong, nonatomic) NSMutableArray *paramDataSource;
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
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib
{
    NSLog(@"%s", __FUNCTION__);
    
    [[self methodCombo] selectItemAtIndex:GET_METHOD];
    
    [self setHeaderDataSource:[[NSMutableArray alloc] init]];
    [self setParamDataSource:[[NSMutableArray alloc] init]];
    
    [self setupSegmentedControls];
}

-(void)setupSegmentedControls
{
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
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[text stringByAppendingString:@"\n"]];
        
        if (color) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
        }
        
        [[[self outputTextView] textStorage] appendAttributedString:attributedString];
        [[self outputTextView] scrollRangeToVisible:NSMakeRange([[[self outputTextView] string] length], 0)];
    });
}

#pragma mark
#pragma mark IBActions

-(IBAction)fetchAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[self urlTextField] stringValue]]];
    
    NSString *httpMethod = [[self methodCombo] objectValueOfSelectedItem];
    
    [request setHTTPMethod:httpMethod];
    
    for (NSDictionary *tempDict in [self headerDataSource]) {
        [request setValue:tempDict[kValue] forHTTPHeaderField:tempDict[kHeaderName]];
    }
    
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
    
    if ([[self logRequestCheckBox] state] == NSOnState) {
        [self appendToOutput:[request HTTPMethod] color:[NSColor greenColor]];
        [self appendToOutput:[NSString stringWithFormat:@"%@", [request allHTTPHeaderFields]] color:[NSColor greenColor]];
        [self appendToOutput:[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] color:[NSColor greenColor]];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                            NSData *data,
                                                                                                            NSError *connectionError) {
        
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if (!connectionError) {
            [self appendToOutput:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] color:nil];
        }
        else {
            NSLog(@"There was a connection error - %@", [connectionError localizedDescription]);
        }
    }];
}

-(IBAction)headerSegContAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSegmentedControl *tempSegCont = sender;
    
    if ([tempSegCont selectedSegment] == 0) {
        NSDictionary *tempDict = @{kHeaderName: kInsertName, kValue: kInsertValue};
        
        [[self headerDataSource] addObject:tempDict];
    }
    else {
        NSUInteger selectedRow = [[self headersTableView] selectedRow];
        
        [[self headerDataSource] removeObjectAtIndex:selectedRow];
    }
    
    [[self headersTableView] reloadData];
    
    [self setupSegmentedControls];
}

-(IBAction)parameterSegContAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    NSSegmentedControl *tempSegCont = sender;
    
    if ([tempSegCont selectedSegment] == 0) {
        NSDictionary *tempDict = @{kParameterName: kInsertName, kValue: kInsertValue};
        
        [[self paramDataSource] addObject:tempDict];
    }
    else {
        NSUInteger selectedRow = [[self headersTableView] selectedRow];
        
        [[self paramDataSource] removeObjectAtIndex:selectedRow];
        
        [[self parametersTableView] reloadData];
    }
    
    [[self parametersTableView] reloadData];
    
    [self setupSegmentedControls];
}

-(IBAction)customPostBodyAction:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
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
@end
