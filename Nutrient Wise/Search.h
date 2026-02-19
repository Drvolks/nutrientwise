//
//  Search.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Finder.h"
#import "LanguageHelper.h"
#import "CellHelper.h"
#import "UISearchBar+UISearchBarLocalized.h"
#ifdef FREE
    @import GoogleMobileAds;
#endif

@interface Search : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ChangeLanguage>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *resultTable;
#ifdef FREE
    @property (weak, nonatomic) IBOutlet GADBannerView  *banner;
#else
    @property (weak, nonatomic) IBOutlet UIView *banner;
#endif


@property (strong, nonatomic) UIView *emptyStateView;
@property (strong, nonatomic) UILabel *emptyStateLabel;

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) Finder *finder;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) CellHelper *cellHelper;

- (void) resetSearch;
- (void) search:(NSString *) text;

@end
