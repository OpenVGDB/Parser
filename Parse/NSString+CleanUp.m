//
//  NSString+NSString_CleanUp.m
//  Parse
//
//  Created by Loic Piguet on 17/12/2013.
//  Copyright (c) 2013 OpenEmu. All rights reserved.
//

#import "NSString+CleanUp.h"

@implementation NSString (CleanUp)

- (NSString *)stringByCleaningUpString
{
    NSString *temp = [[NSString alloc] initWithString:self];
    
    // Could be "not safe"
    //temp = [temp stringByRemovingCompaniesName];
    //temp = [temp stringByNormalizingRomanNumbers];
    
    temp = [temp lowercaseString];
    
    // Could be "not safe"
    //temp = [temp stringByReplacingCommonWords];
    //temp = [temp stringByNormalizingJapaneseStuff];
    
    temp = [temp stringByRemovingWhitespaceAndNonAlphanumeric];
    
    return temp;
}

- (NSString *)stringByRemovingWhitespaceAndNonAlphanumeric
{
    NSString *temp = [[NSString alloc] initWithString:self];
    temp = [[temp componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    return temp;
}

- (NSString *)stringByNormalizingJapaneseStuff
{
    // this is very fuzzy and can break stuff
    NSString *temp = [[NSString alloc] initWithString:self];

    temp = [temp stringByReplacingOccurrencesOfString:@"inguo" withString:@"ingo"];
    temp = [temp stringByReplacingOccurrencesOfString:@"nou" withString:@"nu"];
    temp = [temp stringByReplacingOccurrencesOfString:@"kou" withString:@"ku"];
    temp = [temp stringByReplacingOccurrencesOfString:@"dou" withString:@"do"];
    temp = [temp stringByReplacingOccurrencesOfString:@"oug" withString:@"og"];
    temp = [temp stringByReplacingOccurrencesOfString:@"heno " withString:@"e no"];
    temp = [temp stringByReplacingOccurrencesOfString:@"ousuk" withString:@"osuk"];
    temp = [temp stringByReplacingOccurrencesOfString:@"douky" withString:@"touky"];
    temp = [temp stringByReplacingOccurrencesOfString:@"nsees" withString:@"nshees"];
    temp = [temp stringByReplacingOccurrencesOfString:@"nshizu" withString:@"nshees"];
    temp = [temp stringByReplacingOccurrencesOfString:@"-jou" withString:@"shiro"];
    temp = [temp stringByReplacingOccurrencesOfString:@"mashin" withString:@"majin"];
    temp = [temp stringByReplacingOccurrencesOfString:@"eish" withString:@"eija"];
    temp = [temp stringByReplacingOccurrencesOfString:@"ou Den" withString:@"o den"];
    temp = [temp stringByReplacingOccurrencesOfString:@"o den" withString:@"oden"];
    temp = [temp stringByReplacingOccurrencesOfString:@" e no " withString:@" he no "];
    temp = [temp stringByReplacingOccurrencesOfString:@"eija " withString:@"eisha "];
    temp = [temp stringByReplacingOccurrencesOfString:@"kyatto " withString:@"cat "];
    temp = [temp stringByReplacingOccurrencesOfString:@"gimmi " withString:@"gimme "];
    temp = [temp stringByReplacingOccurrencesOfString:@"kaijuu " withString:@"kaijyu "];
    temp = [temp stringByReplacingOccurrencesOfString:@"nkoku" withString:@"ngoku"];
    temp = [temp stringByReplacingOccurrencesOfString:@"kishin" withString:@"kigami"];
    temp = [temp stringByReplacingOccurrencesOfString:@"ejika" withString:@"eshika"];
    temp = [temp stringByReplacingOccurrencesOfString:@"ougi  " withString:@"ogi "];
    temp = [temp stringByReplacingOccurrencesOfString:@"nkoku" withString:@"ngoku "];
    temp = [temp stringByReplacingOccurrencesOfString:@"uras " withString:@"urasu "];
    temp = [temp stringByReplacingOccurrencesOfString:@"ebas  " withString:@"ebasu "];
    temp = [temp stringByReplacingOccurrencesOfString:@"birdy " withString:@"birdie "];
    temp = [temp stringByReplacingOccurrencesOfString:@"uu " withString:@"u "];
    temp = [temp stringByReplacingOccurrencesOfString:@"ii " withString:@"i "];
    temp = [temp stringByReplacingOccurrencesOfString:@"nn " withString:@"n "];
    temp = [temp stringByReplacingOccurrencesOfString:@"yuuden" withString:@"yuten"];
    temp = [temp stringByReplacingOccurrencesOfString:@"-kko " withString:@"ko"];

    temp = [temp stringByReplacingOccurrencesOfString:@"shenron " withString:@"shen long"];
    temp = [temp stringByReplacingOccurrencesOfString:@"dentetsu" withString:@"densetsu "];
    temp = [temp stringByReplacingOccurrencesOfString:@"toukyou" withString:@"tokyo"];
    temp = [temp stringByReplacingOccurrencesOfString:@"sd gundam world" withString:@"sd gundam"];
    
    return temp;
}

- (NSString *)stringByReplacingCommonWords
{
    NSString *temp = [[NSString alloc] initWithString:self];
    
    //temp = [temp stringByTrimmingCharactersInSet:]
    
    if ([temp hasPrefix:@"the "])
        temp = [temp stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];

    temp = [temp stringByReplacingOccurrencesOfString:@": the " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@"- the " withString:@" "];
    
    temp = [temp stringByReplacingOccurrencesOfString:@" bros." withString:@" brothers"];
    temp = [temp stringByReplacingOccurrencesOfString:@" and " withString:@" & "];
    temp = [temp stringByReplacingOccurrencesOfString:@" in the " withString:@" in "];
    temp = [temp stringByReplacingOccurrencesOfString:@" starring " withString:@" featuring "];
    temp = [temp stringByReplacingOccurrencesOfString:@" feat. " withString:@" featuring "];
    temp = [temp stringByReplacingOccurrencesOfString:@" feat " withString:@" featuring "];
    temp = [temp stringByReplacingOccurrencesOfString:@" part " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@" volume " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@" vol. " withString:@" "];
    
    return temp;
}

- (NSString *)stringByRemovingCompaniesName
{
    NSString *temp = [[NSString alloc] initWithString:self];
    
    temp = [temp stringByReplacingOccurrencesOfString:@"Disney's " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@"Disney " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@"Capcom " withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@"Konamik " withString:@"Konamik "];
    temp = [temp stringByReplacingOccurrencesOfString:@"Datach" withString:@"Konamik "];
    temp = [temp stringByReplacingOccurrencesOfString:@"Hudson's " withString:@""];
    
    return temp;
}

- (NSString *)stringByNormalizingRomanNumbers
{
    // this is very fuzzy and can break stuff
    NSString *temp = [[NSString alloc] initWithString:self];
    
    
	temp = [temp stringByReplacingOccurrencesOfString:@" XIII" withString:@" 13"];
	temp = [temp stringByReplacingOccurrencesOfString:@" XII" withString:@" 12"];
	temp = [temp stringByReplacingOccurrencesOfString:@" XI" withString:@" 11"];
	temp = [temp stringByReplacingOccurrencesOfString:@" X" withString:@" 10"];       // don't want to hurt Mega Man X, do we ?
	temp = [temp stringByReplacingOccurrencesOfString:@" IX" withString:@" 9"];
	temp = [temp stringByReplacingOccurrencesOfString:@" VIII" withString:@" 8"];
	temp = [temp stringByReplacingOccurrencesOfString:@" VII" withString:@" 7"];
    temp = [temp stringByReplacingOccurrencesOfString:@" VI" withString:@" 6"];
	temp = [temp stringByReplacingOccurrencesOfString:@" V" withString:@" 5"];
	temp = [temp stringByReplacingOccurrencesOfString:@" IV" withString:@" 4"];
	temp = [temp stringByReplacingOccurrencesOfString:@" III" withString:@" 3"];
	temp = [temp stringByReplacingOccurrencesOfString:@" II" withString:@" 2"];
    
    return temp;
}


@end
