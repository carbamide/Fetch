//
//  Constants.h
//  Fetch
//
//  Created by Josh on 9/7/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#pragma mark Enums

enum {
    GET_METHOD = 0,
    POST_METHOD = 1,
    PUT_METHOD = 2,
    DELETE_METHOD = 3
};
typedef NSUInteger HttpMethod;

#pragma mark Dictionary Constants

static NSString *const kInsertValue = @"Insert Value";
static NSString *const kInsertName = @"Insert Name";
static NSString *const kValue = @"Value";
static NSString *const kHeaderName = @"Header Name";
static NSString *const kParameterName = @"Parameter Name";
static NSString *const kProjectName = @"project_name";
static NSString *const kHeaders = @"headers";
static NSString *const kName = @"name";
static NSString *const kParameters = @"parameters";
static NSString *const kUrls = @"urls";
static NSString *const kUrl = @"url";
static NSString *const kMethod = @"method";
static NSString *const kCustomPayload = @"custom_payload";
static NSString *const kUrlDescription = @"url_description";

#pragma mark String Constants

static NSString *const kRequestSeparator =  @"---------------------------------REQUEST--------------------------------------";
static NSString *const kResponseSeparator = @"---------------------------------RESPONSE-------------------------------------";
static NSString *const kParsedOutput =      @"------------------------------PARSED OUTPUT-----------------------------------";

#pragma mark User Defaults Names Constants

static NSString *const kSeparatorColor = @"separator_color";
static NSString *const kBackgroundColor = @"background_color";
static NSString *const kForegroundColor = @"foreground_color";
static NSString *const kSuccessColor = @"success_color";
static NSString *const kFailureColor = @"failure_color";
static NSString *const kPingForReachability = @"ping_for_reachability";
static NSString *const kFrequencyToPing = @"frequency_to_ping";
static NSString *const kSplitViewPosition = @"split_view_position";
static NSString *const kParseHtmlInOutput = @"parse_html_in_output";

#pragma mark File Type Constants

static NSString *const kUTITypePublicFile = @"public.file-url";

#pragma mark XIB/NIB Name Constants

static NSString *const kMainWindowXib = @"MainWindow";
static NSString *const kJsonViewerWindowXib = @"JsonViewerWindowController";

#pragma mark Notification Constants

static NSString *const kAddUrlNotification = @"ADD_URL";
static NSString *const kHideIcons = @"HIDE_ICONS";
static NSString *const kShowIcons = @"SHOW_ICONS";

#pragma mark Sizing Constants

static int const kProjectListSplitViewSide = 0;
static int const kMinimumSplitViewSize = 300;
