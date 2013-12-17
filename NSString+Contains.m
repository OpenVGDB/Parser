//
//  NSString+Contains.m
//  Parse
//

#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end
