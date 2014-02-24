//
//  FetchURLConnection.h
//  Fetch for OSX
//
//  Created by Joshua Barrow on 10/31/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

@import Foundation;

@interface FetchURLConnection : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) void(^completionHandler)(NSURLResponse *response, NSData *data, NSError *error);

+ (FetchURLConnection *)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler;
- (void)start;
- (void)cancel;

@end
