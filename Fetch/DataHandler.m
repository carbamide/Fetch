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
    
    [tempProject setName:importedDictionary[@"project_name"]];
    
    for (NSDictionary *tempDict in importedDictionary[@"headers"]) {
        Headers *tempHeader = [Headers create];
        
        [tempHeader setName:tempDict[@"name"]];
        [tempHeader setValue:tempDict[@"value"]];
        
        [tempProject addHeadersObject:tempHeader];
    }
    
    for (NSDictionary *tempDict in importedDictionary[@"parameters"]) {
        Parameters *tempParam = [Parameters create];
        
        [tempParam setName:tempDict[@"name"]];
        [tempParam setValue:tempDict[@"value"]];
        
        [tempProject addParametersObject:tempParam];
    }
    
    for (NSDictionary *tempDict in importedDictionary[@"urls"]) {
        Urls *tempUrl = [Urls create];
        
        [tempUrl setUrl:tempDict[@"url"]];
        [tempUrl setMethod:tempDict[@"method"]];
        
        [tempProject addUrlsObject:tempUrl];
    }
    
    return [tempProject save];
}

+(NSDictionary *)exportProject:(Projects *)project toUrl:(NSURL *)url
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    [returnDictionary setObject:[project name] forKey:@"project_name"];
    
    NSMutableArray *headerArray = [NSMutableArray array];
    NSMutableArray *parameterArray = [NSMutableArray array];
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (Headers *tempHeader in [project headers]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        [tempDict setObject:[tempHeader name] forKey:@"name"];
        [tempDict setObject:[tempHeader value] forKey:@"value"];
        
        [headerArray addObject:tempDict];
    }
    
    for (Parameters *tempParameter in [project parameters]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        [tempDict setObject:[tempParameter name] forKey:@"name"];
        [tempDict setObject:[tempParameter value] forKey:@"value"];
        
        [parameterArray addObject:tempDict];
    }
    
    for (Urls *tempUrl in [project urls]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        [tempDict setObject:[tempUrl url] forKey:@"url"];
        [tempDict setObject:[tempUrl method] forKey:@"method"];
        
        [urlArray addObject:tempDict];
    }
    
    if ([headerArray count] > 0) {
        [returnDictionary setObject:headerArray forKey:@"headers"];
    }
    
    if ([parameterArray count] > 0) {
        [returnDictionary setObject:parameterArray forKey:@"parameters"];
    }
    
    if ([urlArray count] > 0) {
        [returnDictionary setObject:urlArray forKey:@"urls"];
    }
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:returnDictionary];

    [encodedData writeToURL:url atomically:YES];
    
    return returnDictionary;
}
@end
