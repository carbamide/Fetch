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
#import "Projects.h"
#import "Headers.h"

@implementation ProjectHandler

+(BOOL)importFromData:(NSData *)data
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    NSDictionary *importedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    Projects *tempProject = [Projects create];
    
    [tempProject setName:importedDictionary[kProjectName]];
    
    for (NSDictionary *tempDict in importedDictionary[kUrls]) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setCreatedAt:[NSDate date]];
        [tempUrl setUrl:tempDict[kUrl]];
        [tempUrl setMethod:tempDict[kMethod]];
        
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

+(BOOL)importFromPath:(NSString *)path
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

    NSDictionary *importedDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    Projects *tempProject = [Projects create];
    
    [tempProject setName:importedDictionary[kProjectName]];
    
    for (NSDictionary *tempDict in importedDictionary[kUrls]) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setCreatedAt:[NSDate date]];
        [tempUrl setUrl:tempDict[kUrl]];
        [tempUrl setMethod:tempDict[kMethod]];
        
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
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif

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
