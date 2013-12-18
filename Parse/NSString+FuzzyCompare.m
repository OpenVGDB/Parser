//
//  NSString+FuzzyCompare.m
//
//  tweaked by loic on 18.12.2013

#import "NSString+FuzzyCompare.h"

// MACRO's magic: MIN for 3 arguments
#define SMALLEST(a,b,c)   (((((a)>(b))?(b):(a))>(c))?(c):((((a)>(b))?(b):(a))))


@implementation NSString(FuzzyCompare)

- (float)similarWithString:(NSString *)secondString
{
    float distance = [self distanceWithString:secondString];
    float similarities = 100 - (100 / ( (float)[self length] + (float)[secondString length])) * distance;
    
    return similarities;
}

- (float) distanceWithString: (NSString *) secondString
{
     // normalize
     NSString * firstString = [NSString stringWithString: self];
     [firstString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
     [secondString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
     firstString = [firstString lowercaseString];
     secondString = [secondString lowercaseString];

     // Step 1
     int k, i, j, cost, * d, distance;

     long n = [firstString length];
     long m = [secondString length];

     if( n++ != 0 && m++ != 0 ) {

         d = malloc( sizeof(int) * m * n );

         // Step 2
         for( k = 0; k < n; k++)
             d[k] = k;

         for( k = 0; k < m; k++)
             d[ k * n ] = k;

         // Step 3 and 4
         for( i = 1; i < n; i++ )
             for( j = 1; j < m; j++ ) {

                 // Step 5
                 if( [firstString characterAtIndex: i-1] == 
                      [secondString characterAtIndex: j-1] )
                     cost = 0;
                 else
                     cost = 1;

                 // Step 6
                 d[ j * n + i ] = SMALLEST( d[ (j - 1) * n + i ] + 1,
                                            d[ j * n + i - 1 ] +  1,
                                            d[ (j - 1) * n + i -1 ] + cost );
                                            
    
                // Step 7 - This conditional adds Damerau transposition to Levenshtein distance
				if( i>1 && j>1 && [firstString characterAtIndex: i-1] ==
					[secondString characterAtIndex: j-2] &&
					[firstString characterAtIndex: i-2] ==
					[secondString characterAtIndex: j-1] )
				{
					d[ j * n + i] = MIN( d[ j * n + i ], d[ (j - 2) * n + i - 2 ] + cost );
				}
                
                //*/
             }

         distance = d[ n * m - 1 ];

         free( d );

         return distance;
     }
     
     return 0.0;
}

@end

