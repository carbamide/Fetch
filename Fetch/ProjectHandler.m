//
//  DataHandler.m
//  Fetch
//
//  Created by Josh on 9/8/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ProjectHandler.h"
#import "Constants.h"
#import "Projects.h"
#import "Urls.h"
#import "Parameters.h"
#import "Headers.h"

@implementation ProjectHandler

+(BOOL)importFromPath:(NSString *)path
{
    NSDictionary *importedDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    Projects *tempProject = [Projects create];
    
    [tempProject setName:importedDictionary[kProjectName]];
    
    for (NSDictionary *tempDict in importedDictionary[kUrls]) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setCreatedAt:[NSDate date]];
        [tempUrl setUrl:tempDict[kUrl]];
        [tempUrl setMethod:tempDict[kMethod]];
        
        if ([tempDict hasKey:kAuthUsername]) {
            [tempUrl setUsername:tempDict[kAuthUsername]];
        }
        
        if ([tempDict hasKey:kAuthPassword]) {
            [tempUrl setPassword:tempDict[kAuthPassword]];
        }
        
        if ([tempDict hasKey:kUrlDescription]) {
            [tempUrl setUrlDescription:tempDict[kUrlDescription]];
        }
        
        [tempUrl setUrlDescription:tempDict[kUrlDescription]];
        
        if ([tempDict hasKey:kCustomPayload]) {
            [tempUrl setCustomPayload:tempDict[kCustomPayload]];
        }
        
        for (NSDictionary *headerDict in tempDict[kHeaders]) {
            Headers *tempHeader = [Headers create];
            
            [tempHeader setName:headerDict[kName]];
            [tempHeader setValue:headerDict[kValue]];
            
            [tempUrl addHeadersObject:tempHeader];
        }
        
        for (NSDictionary *paramDict in tempDict[kParameters]) {
            Parameters *tempParam = [Parameters create];
            
            [tempParam setName:paramDict[kName]];
            [tempParam setValue:paramDict[kValue]];
            
            [tempUrl addParametersObject:tempParam];
        }
        
        [tempProject addUrlsObject:tempUrl];
    }
    
    return [tempProject save];
}

+(NSDictionary *)exportProject:(Projects *)project toUrl:(NSURL *)url
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    [returnDictionary setObject:[project name] forKey:kProjectName];
    
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (Urls *tempUrl in [project urls]) {
        NSMutableArray *headerArray = [NSMutableArray array];
        NSMutableArray *parameterArray = [NSMutableArray array];
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        [tempDict setObject:[tempUrl url] forKey:kUrl];
        [tempDict setObject:[tempUrl method] forKey:kMethod];
        
        if ([tempUrl urlDescription]) {
            [tempDict setObject:[tempUrl urlDescription] forKey:kUrlDescription];
        }
        
        if ([tempUrl customPayload]) {
            [tempDict setObject:[tempUrl customPayload] forKey:kCustomPayload];
        }
        
        for (Headers *tempHeader in [tempUrl headers]) {
            NSMutableDictionary *headerTempDict = [NSMutableDictionary dictionary];
            
            [headerTempDict setObject:[tempHeader name] forKey:kName];
            [headerTempDict setObject:[tempHeader value] forKey:kValue];
            
            [headerArray addObject:headerTempDict];
        }
        
        for (Parameters *tempParameter in [tempUrl parameters]) {
            NSMutableDictionary *paramTempDict = [NSMutableDictionary dictionary];
            
            [paramTempDict setObject:[tempParameter name] forKey:kName];
            [paramTempDict setObject:[tempParameter value] forKey:kValue];
            
            [parameterArray addObject:paramTempDict];
        }
        
        if ([headerArray count] > 0) {
            [tempDict setObject:headerArray forKey:kHeaders];
        }
        
        if ([parameterArray count] > 0) {
            [tempDict setObject:parameterArray forKey:kParameters];
        }
        
        if ([[tempUrl username] length] > 0) {
            [tempDict setObject:[tempUrl username] forKey:kAuthUsername];
        }
        
        if ([[tempUrl password] length] > 0) {
            [tempDict setObject:[tempUrl password] forKey:kAuthPassword];
        }
        
        [urlArray addObject:tempDict];
    }
    
    if ([urlArray count] > 0) {
        [returnDictionary setObject:urlArray forKey:kUrls];
    }
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:returnDictionary];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
        
        if (error) {
            NSLog(@"%@", [error description]);
        }
    }
    
    [encodedData writeToURL:url atomically:YES];
    
    return returnDictionary;
}

+(NSString *)exportProjectAsPlainText:(Projects *)project toUrl:(NSURL *)url
{
    NSMutableString *returnString = [[NSMutableString alloc] init];
    
    [returnString appendFormat:@"Project Name: %@\n", [project name]];
    
    NSMutableString *urlsString = [[NSMutableString alloc] init];
    
    for (Urls *tempUrl in [project urls]) {
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendFormat:@"URL: %@\n", [tempUrl url]];
        [urlString appendFormat:@"URL Description: %@\n", [tempUrl urlDescription]];
        [urlString appendFormat:@"Method: %@\n", [ProjectHandler methodStringForMethodType:[[tempUrl method] intValue]]];
        [urlString appendFormat:@"Custom Payload: %@\n", [tempUrl customPayload]];
        
        NSMutableString *headerString = [[NSMutableString alloc] init];
        NSMutableString *parameterString = [[NSMutableString alloc] init];
        
        for (Headers *tempHeader in [tempUrl headers]) {
            [headerString appendFormat:@"Header Name: %@\nHeader Value: %@\n", [tempHeader name], [tempHeader value]];
        }
        
        for (Parameters *tempParameter in [tempUrl parameters]) {
            [parameterString appendFormat:@"Parameter Name: %@\nParameter Value: %@\n", [tempParameter name], [tempParameter value]];
        }
        
        [urlString appendFormat:@"Headers: \n%@\n", headerString];
        [urlString appendFormat:@"Parameters: \n%@\n", parameterString];
        [urlString appendFormat:@"Username: %@\n", [tempUrl username]];
        [urlString appendFormat:@"Password: %@\n", [tempUrl password]];
        [urlString appendString:@"\n____________\n"];
        
        [urlsString appendFormat:@"%@\n", urlString];
    }
    
    [returnString appendFormat:@"URLs: \n%@\n", urlsString];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
        
        if (error) {
            NSLog(@"%@", [error description]);
        }
    }
    
    [returnString writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return returnString;
}

+(NSString *)methodStringForMethodType:(int) method
{
    NSString *returnString = nil;
    
    switch (method) {
        case 0:
            returnString = @"GET";
            break;
        case 1:
            returnString = @"POST";
            break;
        case 2:
            returnString = @"PUT";
            break;
        case 3:
            returnString = @"DELETE";
            break;
            
        default:
            break;
    }
    
    return returnString;
}
@end
