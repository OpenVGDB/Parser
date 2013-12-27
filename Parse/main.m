//
//  main.m
//  Parse
//

#import <Foundation/Foundation.h>
//#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#import "NSString+QuoteFix.h"
#import "NSString+Contains.h"
#import "CHCSVParser.h"
#import "NSString+CleanUp.h"

@interface CSV: NSObject {
@public
    NSMutableArray *sourceReturnArray;
    NSMutableArray *coversReturnArray;
    NSMutableArray *metadataReturnArray;
}

- (NSArray *)arrayFromCSV:(NSString *)csv returnArray:(NSArray *)returnArray format:(NSArray *)format ignoreHeader:(BOOL)ignore;
- (void)writeLine;

@end

static NSDictionary *releases;
static NSString *boxFront, *boxBack, *cart, *disc, *description, *developer, *publisher, *genre, *releaseDate, *referenceURL;

@implementation CSV

-(id) init {
    if (self = [super init])
    {
        sourceReturnArray = [NSMutableArray array];
        coversReturnArray = [NSMutableArray array];
        metadataReturnArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)arrayFromCSV:(NSString *)path returnArray:(NSMutableArray *)returnArray format:(NSArray *)format ignoreHeader:(BOOL)ignore {
    NSArray *dataRows = [NSArray arrayWithContentsOfCSVFile:path];
    NSInteger expectedRowComponents = [[dataRows objectAtIndex:0] count];
    if ([format count] > expectedRowComponents) {
        // more format keys than components
        return nil;
    }
    for ( NSInteger i = 0; i < [dataRows count]; i++ ) {
        if (i == 0 && ignore)
            // ignore first line in csv, "header"
            continue;
        NSArray *rowComponents = [dataRows objectAtIndex:i];
        if ( [rowComponents count] != expectedRowComponents )
            continue;
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        for ( NSInteger j = 0; j < [format count]; j++ ) {
            if ( [format objectAtIndex:j] != [NSNull null] ) {
                [tmpDict setObject:[rowComponents objectAtIndex:j] forKey:[format objectAtIndex:j]];
            }
        }
        [returnArray addObject:tmpDict];
    }
    return returnArray;
}

- (void)writeLine
{
    NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
          [releases valueForKeyPath:@"romID"],
          [releases valueForKeyPath:@"releaseTitleName"],
          [releases valueForKeyPath:@"regionLocalizedID"],
          [releases valueForKeyPath:@"TEMPregionLocalizedName"],
          [releases valueForKeyPath:@"TEMPsystemShortName"],
          [releases valueForKeyPath:@"TEMPsystemName"],
          boxFront,
          boxBack,
          cart,
          disc,
          description,
          developer,
          publisher,
          genre,
          releaseDate,
          referenceURL
          );
}

@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        CSV *dataSource = [[CSV alloc] init];

        // Setup source CSV and format
        NSString *sourceCSVPATH = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"releases/source-32x.txt"];
        
        NSArray *sourceFormat = @[ @"releaseID",
                                   @"romID",
                                   @"releaseTitleName",
                                   @"regionLocalizedID",
                                   @"TEMPregionLocalizedName",
                                   @"TEMPsystemShortName",
                                   @"TEMPsystemName",
                                   @"releaseCoverFront",
                                   @"releaseCoverBack",
                                   @"releaseCoverCart",
                                   @"releaseCoverDisc",
                                   @"releaseDescription",
                                   @"releaseDeveloper",
                                   @"releasePublisher",
                                   @"releaseGenre",
                                   @"releaseDate",
                                   @"releaseReferenceURL",
                                   ];

        [dataSource arrayFromCSV:sourceCSVPATH returnArray:dataSource->sourceReturnArray format:sourceFormat ignoreHeader:YES];


        // Setup covers CSV and format
        NSString *coversCSVPATH = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"covers/32X.csv"];
        
        NSArray *coversFormat = @[ @"Title",
                                   @"CoverRegionName",
                                   @"CoverType",
                                   @"CoverURL"
                                   ];

        [dataSource arrayFromCSV:coversCSVPATH returnArray:dataSource->coversReturnArray format:coversFormat ignoreHeader:YES];

        // Setup metadata CSV and format
        NSString *metadataCSVPATH = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"metadata/32X.csv"];
        
        NSArray *metadataFormat = @[ @"Title",
                                     @"Genres",
                                     @"Description",
                                     @"GameFAQs_Reader_Rating",
                                     @"GameFAQs_Rating",
                                     @"MetaCritics_MetaScore",
                                     @"Developer",
                                     @"ReleaseDate",
                                     @"ReferenceURL"
                                     ];

        [dataSource arrayFromCSV:metadataCSVPATH returnArray:dataSource->metadataReturnArray format:metadataFormat ignoreHeader:YES];

        //NSLog(@"%@", [dataSource->sourceReturnArray objectAtIndex:2]);
        //NSLog(@"%@", [dataSource->coversReturnArray objectAtIndex:2]);
        //NSLog(@"%@", [dataSource->metadataReturnArray objectAtIndex:2]);

        // Write the CSV header
        NSLog(@"\"romID\";\"releaseTitleName\";\"regionLocalizedID\";\"TEMPregionLocalizedName\";\"TEMPsystemShortName\";\"TEMPsystemName\";\"releaseCoverFront\";\"releaseCoverBack\";\"releaseCoverCart\";\"releaseCoverDisc\";\"releaseDescription\";\"releaseDeveloper\";\"releasePublisher\";\"releaseGenre\";\"releaseDate\";\"releaseReferenceURL\"");

        BOOL matchFound = NO;
        int matchCounter = 0;
        int printCounter = 0;

        // Loop through the 'titles' array and 'covers' array and look for matches
        for (releases in dataSource->sourceReturnArray) {

            @autoreleasepool {
                // Default these fields to NULL for clean DB import
                boxFront = @"NULL";
                boxBack = @"NULL";
                cart = @"NULL";
                disc = @"NULL";
                description = @"NULL";
                developer = @"NULL";
                publisher = @"NULL";
                genre = @"NULL";
                releaseDate = @"NULL";
                referenceURL = @"NULL";
                
                // Clean up the releases title only once
                NSString *releaseTitle = [[releases valueForKeyPath:@"releaseTitleName"] stringByCleaningUpString];

                // Match covers to titles
                for (NSDictionary *covers in dataSource->coversReturnArray) {
                        // TODO: Add in loic's secret sauce matching for Jap region titles
                        // TODO: Possibly use https://github.com/thetron/StringScore or https://gist.github.com/boratlibre/1593632
                        // Did we find an Exact Match "title" between 'releases' and 'covers' arrays?
                    
                        if (// Remove all non-alphanumeric chars and make lowercase as to increase matches
                            [[[covers valueForKeyPath:@"Title"] stringByCleaningUpString] isEqualToString:releaseTitle])
                            
                        {
                            matchFound = YES;

                            // Match metadata to titles
                            for (NSDictionary *metadata in dataSource->metadataReturnArray)
                            {
                                if ([[[metadata valueForKeyPath:@"Title"] stringByCleaningUpString] isEqualToString:releaseTitle])
                                {
                                    // Default these fields to NULL for clean DB import and remove space found at end of "ReleaseDate" field in the metadata CSVs
                                    genre = [[metadata valueForKeyPath:@"Genres"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"Genres"];
                                    description = [[metadata valueForKeyPath:@"Description"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"Description"];
                                    developer = [[metadata valueForKeyPath:@"Developer"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"Developer"];
                                    releaseDate = [[[[metadata valueForKeyPath:@"ReleaseDate"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"ReleaseDate"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    referenceURL = [[metadata valueForKeyPath:@"ReferenceURL"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"ReferenceURL"];
                                    break;
                                }
                            }

                            // USA region
                            if ([[releases valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"USA\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(US, "])
                            {
                                // get the front cover
                                if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                                {
                                    boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    continue;
                                }
                                // get the back cover
                                else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                                {
                                    boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                }

                                [dataSource writeLine];
                                matchCounter++;
                                printCounter++;
                                break;
                            }
                            // Europe region
                            else if ([[releases valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Europe\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(EU, "])
                            {
                                // get the front cover
                                if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                                {
                                    boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    continue;
                                }
                                // get the back cover
                                else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                                {
                                    boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                }

                                [dataSource writeLine];
                                matchCounter++;
                                printCounter++;
                                break;
                            }
                            // Japan region
                            else if ([[releases valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Japan\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(JP, "])
                            {
                                // get the front cover
                                if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                                {
                                    boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    continue;
                                }
                                // get the back cover
                                else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                                {
                                    boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                }

                                [dataSource writeLine];
                                matchCounter++;
                                printCounter++;
                                break;
                            }
                            // Asia region
                            else if ([[releases valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Asia\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(AS, "])
                            {
                                // get the front cover
                                if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                                {
                                    boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    continue;
                                }
                                // get the back cover
                                else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                                {
                                    boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                }

                                [dataSource writeLine];
                                matchCounter++;
                                printCounter++;
                                break;
                            }
                            // Australia region
                            else if ([[releases valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Australia\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(AU, "])
                            {
                                // get the front cover
                                if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                                {
                                    boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    continue;
                                }
                                // get the back cover
                                else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                                {
                                    boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                }

                                [dataSource writeLine];
                                matchCounter++;
                                printCounter++;
                                break;
                            }
                            // Brazil region
                            else if ([[releases valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Brazil\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(SA, "])
                            {
                                // get the front cover
                                if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                                {
                                    boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    continue;
                                }
                                // get the back cover
                                else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                                {
                                    boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                }

                                [dataSource writeLine];
                                matchCounter++;
                                printCounter++;
                                break;
                            }
                            // Korea region
                            else if ([[releases valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Brazil\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(KO, "])
                            {
                                // get the front cover
                                if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                                {
                                    boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    continue;
                                }
                                // get the back cover
                                else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                                {
                                    boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                }

                                [dataSource writeLine];
                                matchCounter++;
                                printCounter++;
                                break;
                            }
                        }
                        else
                            matchFound = NO;
                        
                    } // for-loop covers
                    
                    // No "Exact Match" so print the release anyway
                    if (!matchFound)
                    {
                        [dataSource writeLine];
                        printCounter++;
                    }
                    
                    
                } // autorelease pool title
                
            } // for-loop titles
            
            NSLog(@"Cover Matches (this number is wrong): %d", matchCounter);
            NSLog(@"Releases: %lu", (unsigned long)[dataSource->sourceReturnArray count]);
            NSLog(@"Printed:  %d", printCounter);
        }
    return 0;
}
