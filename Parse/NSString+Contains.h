//
//  NSString+Contains.h
//  Parse
//

#import <Foundation/Foundation.h>

@interface NSString (Contains)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end
