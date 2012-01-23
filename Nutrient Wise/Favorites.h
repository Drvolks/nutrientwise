//
//  Favorites.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteHelper.h"
#import "Finder.h"
#import "LanguageHelper.h"

@interface Favorites : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FavoriteHelper *favoriteHelper;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *favorites;
@property (strong, nonatomic) Finder *finder;
@property (strong, nonatomic) LanguageHelper *languageHelper;

- (void) loadFavorites;

@end
