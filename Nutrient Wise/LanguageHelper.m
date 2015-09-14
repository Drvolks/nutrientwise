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
#define kEnglish @"en"
#define kFrenchNameColumn @"frenchName"
#define kEnglishNameColumn @"englishName"
#define kBundleExt @"lproj"
#define kDefaultValue @""

@implementation LanguageHelper

@synthesize bundle;

static LanguageHelper *instance = nil;

+ (id) sharedInstance {
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}

- (BOOL) french {
    NSString *language = [self language];
    
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
    if(bundle == nil) {
        NSString *langue = [self language];
        NSString *path = [[ NSBundle mainBundle ] pathForResource:langue ofType:kBundleExt ];
        bundle = [NSBundle bundleWithPath:path];
    }
    
    return [bundle localizedStringForKey:key value:kDefaultValue table:nil];
}

- (NSString *) language {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *language = [settings objectForKey:kLanguageSetting];
    
    NSUInteger length = [language length];
    if(length > 2) {
        language = [language substringToIndex:2];
    }
    
    if(![language isEqualToString:kFrench] && ![language isEqualToString:kEnglish]) {
        language = kEnglish;
    }
    
    return language;
}

- (void) setLanguage:(NSString *)language {
     NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:language forKey:kLanguageSetting];
    [settings synchronize];
    
    NSString *path = [[ NSBundle mainBundle ] pathForResource:[self language] ofType:kBundleExt ];
    bundle = [NSBundle bundleWithPath:path];
}

- (NSArray *) supportedLanguages {
    NSMutableArray *supportedLanguages = [[NSMutableArray alloc] initWithCapacity:2];
    [supportedLanguages addObject:kEnglish];
    [supportedLanguages addObject:kFrench];
    
    return supportedLanguages;
}

@end
