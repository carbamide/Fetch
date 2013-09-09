//
//  DataHandler.m
//  Fetch
//
//  Created by Josh on 9/8/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "DataHandler.h"
#import "Constants.h"
#import "Projects.h"
#import "Urls.h"
#import "Parameters.h"
#import "Projects.h"
#import "Headers.h"

@implementation DataHandler

+(BOOL)importFromPath:(NSString *)path
{
    NSDictionary *importedDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    Projects *tempProject = [Projects create];
    
    [tempProject setName:importedDictionary[kProjectName]];
    
    for (NSDictionary *tempDict in importedDictionary[kUrls]) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setUrl:tempDict[kUrl]];
        [tempUrl setMethod:tempDict[kMethod]];
        
        if ([tempDict hasKey:kCustomPayload]) {
            [tempUrl setCustomPayload:tempDict[kCustomPayload]];
        }
        
        for (NSDictionary *tempDict in tempDict[kHeaders]) {
            Headers *tempHeader = [Headers create];
            
            [tempHeader setName:tempDict[kName]];
            [tempHeader setValue:tempDict[kValue]];
            
            [tempUrl addHeadersObject:tempHeader];
        }
        
        for (NSDictionary *tempDict in tempDict[kParameters]) {
            Parameters *tempParam = [Parameters create];
            
            [tempParam setName:tempDict[kName]];
            [tempParam setValue:tempDict[kValue]];
            
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
        
        if ([tempUrl customPayload]) {
            [tempDict setObject:[tempUrl customPayload] forKey:kCustomPayload];
        }
        
        for (Headers *tempHeader in [tempUrl headers]) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            
            [tempDict setObject:[tempHeader name] forKey:kName];
            [tempDict setObject:[tempHeader value] forKey:kValue];
            
            [headerArray addObject:tempDict];
        }
        
        for (Parameters *tempParameter in [tempUrl parameters]) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            
            [tempDict setObject:[tempParameter name] forKey:kName];
            [tempDict setObject:[tempParameter value] forKey:kValue];
            
            [parameterArray addObject:tempDict];
        }
        
        if ([headerArray count] > 0) {
            [tempDict setObject:headerArray forKey:kHeaders];
        }
        
        if ([parameterArray count] > 0) {
            [tempDict setObject:parameterArray forKey:kParameters];
        }
        
        [urlArray addObject:tempDict];
    }
    
    if ([urlArray count] > 0) {
        [returnDictionary setObject:urlArray forKey:kUrls];
    }
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:returnDictionary];
    
    [encodedData writeToURL:url atomically:YES];
    
    return returnDictionary;
}
@end
