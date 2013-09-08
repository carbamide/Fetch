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
#import "CustomPayload.h"

@implementation DataHandler

+(BOOL)importFromPath:(NSString *)path
{
    NSDictionary *importedDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    Projects *tempProject = [Projects create];
    
    [tempProject setName:importedDictionary[kProjectName]];
    
    for (NSDictionary *tempDict in importedDictionary[kHeaders]) {
        Headers *tempHeader = [Headers create];
        
        [tempHeader setName:tempDict[kName]];
        [tempHeader setValue:tempDict[kValue]];
        
        [tempProject addHeadersObject:tempHeader];
    }
    
    for (NSDictionary *tempDict in importedDictionary[kParameters]) {
        Parameters *tempParam = [Parameters create];
        
        [tempParam setName:tempDict[kName]];
        [tempParam setValue:tempDict[kValue]];
        
        [tempProject addParametersObject:tempParam];
    }
    
    for (NSDictionary *tempDict in importedDictionary[kUrls]) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setUrl:tempDict[kUrl]];
        [tempUrl setMethod:tempDict[kMethod]];
        
        if (tempDict[kCustomPayload]) {
            CustomPayload *tempPayload = [CustomPayload create];
            
            [tempPayload setPayload:tempDict[kCustomPayload]];
            
            [tempUrl setCustomPayload:tempPayload];
        }
        
        [tempProject addUrlsObject:tempUrl];
    }
    
    return [tempProject save];
}

+(NSDictionary *)exportProject:(Projects *)project toUrl:(NSURL *)url
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    [returnDictionary setObject:[project name] forKey:kProjectName];
    
    NSMutableArray *headerArray = [NSMutableArray array];
    NSMutableArray *parameterArray = [NSMutableArray array];
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (Headers *tempHeader in [project headers]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        [tempDict setObject:[tempHeader name] forKey:kName];
        [tempDict setObject:[tempHeader value] forKey:kValue];
        
        [headerArray addObject:tempDict];
    }
    
    for (Parameters *tempParameter in [project parameters]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        [tempDict setObject:[tempParameter name] forKey:kName];
        [tempDict setObject:[tempParameter value] forKey:kValue];
        
        [parameterArray addObject:tempDict];
    }
    
    for (Urls *tempUrl in [project urls]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        [tempDict setObject:[tempUrl url] forKey:kUrl];
        [tempDict setObject:[tempUrl method] forKey:kMethod];
        [tempDict setObject:[[tempUrl customPayload] payload] forKey:kCustomPayload];
        
        [urlArray addObject:tempDict];
    }
    
    if ([headerArray count] > 0) {
        [returnDictionary setObject:headerArray forKey:kHeaders];
    }
    
    if ([parameterArray count] > 0) {
        [returnDictionary setObject:parameterArray forKey:kParameters];
    }
    
    if ([urlArray count] > 0) {
        [returnDictionary setObject:urlArray forKey:kUrls];
    }
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:returnDictionary];

    [encodedData writeToURL:url atomically:YES];
    
    return returnDictionary;
}
@end
