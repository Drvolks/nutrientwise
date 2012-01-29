//
//  Settings.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"
#import "Finder.h"
#import "SettingsLanguage.h"

@interface Settings : UIViewController <UITableViewDelegate, UITableViewDataSource, SettingsLanguageDelegate, ChangeLanguage>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) Finder *finder;

@end
