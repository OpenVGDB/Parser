//
//  NSString+FuzzyCompare.m
//
//  tweaked by loic on 18.12.2013

#import <Foundation/Foundation.h>

/**
 Fuzzy string compare. Determine the Levenshtein-Damerau edit distance (insert,delete,susbtitute and swap) based on
 http://weblog.wanderingmango.com/articles/14/fuzzy-string-matching-and-the-principle-of-pleasant-surprises and
 http://en.wikipedia.org/wiki/Damerau–Levenshtein_distance
 */
@interface NSString(FuzzyCompare)

/** Returns a percentage of the similarities between the two string
 @param secondString The (NSString *) to fuzzy compare with.
 @return A float, percentage of similarities
 */
- (float)similarWithString:(NSString *)secondString;

/** Returns the Levenshtein distance between two strings
    @param secondString The (NSString *) to fuzzy compare with.
    @return A float representing the distance (number of permutation needed from one string to get the other)
 */
- (float)distanceWithString:(NSString *) secondString;

@end
