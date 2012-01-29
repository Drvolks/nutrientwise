//
//  Profiles.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"
#import "Finder.h"
#import "ProfileSelection.h"
#import "ProfileHelper.h"

@interface Profiles : UIViewController <UITableViewDelegate, UITableViewDataSource, ProfileSelectionDelegate, ChangeLanguage>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *profileInformation;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) ProfileHelper *profileHelper;
@property (strong, nonatomic) Finder *finder;

- (void) displayProfileInformation;

@end
