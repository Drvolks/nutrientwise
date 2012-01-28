//
//  Language.h
//  Nutrient Wise
//
//  Created by drvolks on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageHelper : NSObject

@property (strong, nonatomic) NSBundle *bundle;

- (BOOL) french;
- (NSString *) nameColumn;
- (NSString *) localizedString:(NSString *)key;
- (NSString *) language;
- (void) setLanguage:(NSString *)language;
- (NSArray *) supportedLanguages;

@end
