//
//  NSString+QuoteFix.m
//  Parse
//

#import "NSString+QuoteFix.h"

@implementation NSString (QuoteFix)

- (NSArray *)componentsSeparatedByComma
{
    BOOL insideQuote = NO;
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (NSString *s in [self componentsSeparatedByString:@","]) {
        if ([s rangeOfString:@"\""].location == NSNotFound) {
            if (insideQuote) {
                [tmp addObject:s];
            } else {
                [results addObject:s];
            }
        } else {
            if (insideQuote) {
                insideQuote = NO;
                [tmp addObject:s];
                [results addObject:[tmp componentsJoinedByString:@","]];
                tmp = nil;
                tmp = [[NSMutableArray alloc] init];
            } else {
                insideQuote = YES;
                [tmp addObject:s];
            }
        }
    }
    
    return results;
}

@end