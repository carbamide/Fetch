//
//  FetchURLConnection.m
//  Fetch for OSX
//
//  Created by Joshua Barrow on 10/31/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "FetchURLConnection.h"

@interface NSURLRequest(Private)
+(void)setAllowsAnyHTTPSCertificate:(BOOL)inAllow forHost:(NSString *)inHost;
@end

@interface FetchURLConnection ()
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSMutableData *responseData;
@end

@implementation FetchURLConnection

@synthesize request, queue, completionHandler;

+ (FetchURLConnection *)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler
{
    FetchURLConnection *result = [[FetchURLConnection alloc] init];
    
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[[request URL] host]];
    
    [result setRequest:request];
    [result setQueue:queue];
    [result setCompletionHandler:completionHandler];
    
    [result start];
    return result;
}

- (void)dealloc
{
    [self cancel];
}

- (void)start
{
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [_connection scheduleInRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
    if (_connection) {
        [_connection start];
    }
    else {
        if (completionHandler) completionHandler(nil, nil, nil); completionHandler = nil;
    }
}

- (void)cancel
{
    [_connection cancel];
    
    _connection = nil;
    completionHandler = nil;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSHTTPURLResponse *)response
{
    _response = response;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
    if (!_responseData) {
        _responseData = [NSMutableData dataWithData:data];
    }
    else {
        [_responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _connection = nil;
    
    if (completionHandler) {
        void(^b)(NSURLResponse *response, NSData *data, NSError *error) = completionHandler;
        
        completionHandler = nil;
        
        [queue addOperationWithBlock:^{b(_response, _responseData, nil);}];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _connection = nil;
    
    if (completionHandler) {
        void(^b)(NSURLResponse *response, NSData *data, NSError *urlError) = completionHandler;
        
        completionHandler = nil;
        
        [queue addOperationWithBlock:^{b(_response, _responseData, error);}];
    }
}

#if TARGET_IPHONE_SIMULATOR
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[challenge sender] useCredential:[NSURLCredential credentialForTrust:[[challenge protectionSpace] serverTrust] forAuthenticationChallenge:challenge];
}
#endif

@end
