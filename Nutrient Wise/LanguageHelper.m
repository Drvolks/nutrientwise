//
//  Language.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LanguageHelper.h"

#define kLanguageSetting @"language"
#define kFrench @"fr"
#define kFrenchNameColumn @"frenchName"
#define kEnglishNameColumn @"englishName"

@implementation LanguageHelper

- (BOOL) french {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *language = [settings objectForKey:kLanguageSetting];
    
    if([language compare:kFrench] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}

- (NSString *) nameColumn {
    if([self french]) {
        return kFrenchNameColumn;
    }
    
    return kEnglishNameColumn;
}

- (NSString *) localizedString:(NSString *)key {
    // TODO implement this
    
    return key;
}

@end
