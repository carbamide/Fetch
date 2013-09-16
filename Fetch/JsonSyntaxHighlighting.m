

#import "JsonSyntaxHighlighting.h"

@interface JsonSyntaxHighlighting()
@property (strong, nonatomic) NSRegularExpression *regex;
@end

@implementation JsonSyntaxHighlighting

- (JsonSyntaxHighlighting *)init
{
    return nil;
}

- (JsonSyntaxHighlighting *)initWithJSON:(id)JSON
{
    self = [super init];
    
    if (self) {
        _JSON = JSON;
        
        [self setRegex:[NSRegularExpression regularExpressionWithPattern:@"^( *)(\".+\" : )?(\"[^\"]*\"|[\\w.+-]*)?([,\\[\\]{}]?,?$)"
                                                                 options:NSRegularExpressionAnchorsMatchLines
                                                                   error:nil]];
        
        if ([NSJSONSerialization isValidJSONObject:[self JSON]]) {
            NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:[self JSON] options:options error:nil];
            
            NSString *o = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            _parsedJSON = o;
            
        }
        else {
            _parsedJSON = [NSString stringWithFormat:@"%@", [self JSON]];
        }
        
        [self setNonStringAttributes:@{NSForegroundColorAttributeName: [[self class] colorWithRGB:0x000080]}];
        [self setStringAttributes:@{NSForegroundColorAttributeName: [[self class] colorWithRGB:0x808000]}];
        [self setKeyAttributes:@{NSForegroundColorAttributeName: [[self class] colorWithRGB:0xa52a2a]}];
    }
    return self;
}

- (NSAttributedString *)highlightJSON
{
    return [self highlightJSONWithPrettyPrint:YES];
}

- (NSAttributedString *)highlightJSONWithPrettyPrint:(BOOL)prettyPrint
{
    NSMutableAttributedString *line = [[NSMutableAttributedString alloc] initWithString:@""];
    
    [self enumerateMatchesWithIndentBlock: ^(NSRange range, NSString *s) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:s attributes:@{}];
        
        if (prettyPrint) {
            [line appendAttributedString:as];
        }
    } keyBlock:^(NSRange range, NSString *s) {
        NSString *key = [s substringToIndex:s.length - 3];
        
        [line appendAttributedString:[[NSAttributedString alloc] initWithString:key attributes:self.keyAttributes]];
        
        NSString *colon = prettyPrint ? @" : " : @":";
        
        [line appendAttributedString:[[NSAttributedString alloc] initWithString:colon attributes:@{}]];
    } valueBlock:^(NSRange range, NSString *s) {
        NSAttributedString *as = nil;
        
        if ([s rangeOfString:@"\""].location == NSNotFound) {
            as = [[NSAttributedString alloc] initWithString:s attributes:self.nonStringAttributes];
        }
        else {
            as = [[NSAttributedString alloc] initWithString:s attributes:self.stringAttributes];
        }
        
        [line appendAttributedString:as];
    } endBlock:^(NSRange range, NSString *s) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:s attributes:@{}];
        
        [line appendAttributedString:as];
        
        if (prettyPrint) {
            [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }];
    
    if ([line isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@""]]) {
        line = [[NSMutableAttributedString alloc] initWithString:[self parsedJSON]];
    }
    
    return line;
}

#pragma mark JSON Parser
- (void)enumerateMatchesWithIndentBlock:(void(^)(NSRange, NSString*))indentBlock
                               keyBlock:(void(^)(NSRange, NSString*))keyBlock
                             valueBlock:(void(^)(NSRange, NSString*))valueBlock
                               endBlock:(void(^)(NSRange, NSString*))endBlock
{
    [[self regex] enumerateMatchesInString:[self parsedJSON]
                            options:0
                              range:NSMakeRange(0, [self parsedJSON].length)
                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSRange indentRange = [match rangeAtIndex:1];
                             NSRange keyRange = [match rangeAtIndex:2];
                             NSRange valueRange = [match rangeAtIndex:3];
                             NSRange endRange = [match rangeAtIndex:4];
                             
                             if (indentRange.location != NSNotFound) {
                                 indentBlock(indentRange, [[self parsedJSON] substringWithRange:indentRange]);
                             }
                             if (keyRange.location != NSNotFound) {
                                 keyBlock(keyRange, [[self parsedJSON] substringWithRange:keyRange]);
                             }
                             if (valueRange.location != NSNotFound) {
                                 valueBlock(valueRange, [[self parsedJSON] substringWithRange:valueRange]);
                             }
                             if (endRange.location != NSNotFound) {
                                 endBlock(endRange, [[self parsedJSON] substringWithRange:endRange]);
                             }
                         }];
}

#pragma mark -
#pragma mark Color Helper Functions
#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
+ (UIColor *)colorWithRGB:(NSInteger)rgbValue
{
    return [[self class] colorWithRGB:rgbValue alpha:1.0];
}

+ (UIColor *)colorWithRGB:(NSInteger)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbValue & 0x00FF00) >> 8 )) / 255.0
                            blue:((float)((rgbValue & 0x0000FF) >> 0 )) / 255.0
                           alpha:alpha];
}
#else
+ (NSColor *)colorWithRGB:(NSInteger)rgbValue
{
    return [[self class] colorWithRGB:rgbValue alpha:1.0];
}

+ (NSColor *)colorWithRGB:(NSInteger)rgbValue alpha:(CGFloat)alpha
{
    return [NSColor colorWithCalibratedRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                                     green:((float)((rgbValue & 0x00FF00) >> 8 )) / 255.0
                                      blue:((float)((rgbValue & 0x0000FF) >> 0 )) / 255.0
                                     alpha:alpha];
}
#endif

@end
