//
//  NSString+NSString_CleanUp.h
//  Parse
//
//  Created by Loic Piguet on 17/12/2013.
//  Copyright (c) 2013 OpenEmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CleanUp)

- (NSString *)stringByCleaningUpString;

- (NSString *)stringByRemovingWhitespaceAndNonAlphanumeric;
- (NSString *)stringByNormalizingJapaneseStuff;
- (NSString *)stringByNormalizingRomanNumbers;

@end
