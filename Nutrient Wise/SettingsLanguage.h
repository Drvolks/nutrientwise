//
//  SettingsLanguage.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"

@protocol SettingsLanguageDelegate <NSObject>
- (void) languageSelected:(NSString *) language;
@end

@interface SettingsLanguage : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithLanguage:(NSString *) pSelectedLanguage;

@property (strong, nonatomic) NSString *selectedLanguage;
@property (strong, nonatomic) NSArray *languages;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (nonatomic, assign) id  <SettingsLanguageDelegate> delegate;  

@end
