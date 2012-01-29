//
//  Language.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChangeLanguage <NSObject>
- (void) languageChanged;
@end

@interface LanguageHelper : NSObject

@property (strong, nonatomic) NSBundle *bundle;

- (BOOL) french;
- (NSString *) nameColumn;
- (NSString *) localizedString:(NSString *)key;
- (NSString *) language;
- (void) setLanguage:(NSString *)language;
- (NSArray *) supportedLanguages;
+ (id) sharedInstance;

@end
