//
//  SearchController.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Finder.h"
#import "Language.h"

@interface Search : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *resultTable;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) Finder *finder;
@property (strong, nonatomic) Language *language;

- (void) resetSearch;
- (void) search:(NSString *) text;

@end
