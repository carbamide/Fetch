//
//  Constants.h
//  Fetch
//
//  Created by Josh on 9/7/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

enum {
    SiteUp = 0,
    SiteDown,
    SiteInconclusive
};
typedef NSUInteger UrlStatus;

enum {
    GET_METHOD = 0,
    POST_METHOD = 1,
    PUT_METHOD = 2,
    DELETE_METHOD = 3
};
typedef NSUInteger HttpMethod;

static NSString *const kInsertValue = @"Insert Value";
static NSString *const kInsertName = @"Insert Name";
static NSString *const kValue = @"Value";
static NSString *const kHeaderName = @"Header Name";
static NSString *const kParameterName = @"Parameter Name";
static NSString *const kRequestSeparator = @"---------------------------------REQUEST--------------------------------------";
static NSString *const kResponseSeparator = @"---------------------------------RESPONSE------------------------------------";
static NSString *const kSeparatorColor = @"separator_color";
static NSString *const kBackgroundColor = @"background_color";
static NSString *const kForegroundColor = @"foreground_color";
static NSString *const kSuccessColor = @"success_color";
static NSString *const kFailureColor = @"failure_color";
static NSString *const kProjectName = @"project_name";
static NSString *const kHeaders = @"headers";
static NSString *const kName = @"name";
static NSString *const kParameters = @"parameters";
static NSString *const kUrls = @"urls";
static NSString *const kUrl = @"url";
static NSString *const kMethod = @"method";
static NSString *const kCustomPayload = @"custom_payload";
static NSString *const kUrlDescription = @"url_description";
static NSString *const kJsonSyntaxHighlighting = @"json_syntax_highlighting";
static NSString *const kPingForReachability = @"ping_for_reachability";
static NSString *const kFrequencyToPing = @"frequency_to_ping";
static NSString *const kUTITypePublicFile = @"public.file-url";

static int const kProjectListSplitViewSide = 0;
static int const kMinimumSplitViewSize = 300;
