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
#import "CellHelper.h"
#import "ArrayHelper.h"

@interface Favorites : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) FavoriteHelper *favoriteHelper;
@property (strong, nonatomic) NSMutableArray *favorites;
@property (strong, nonatomic) Finder *finder;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) CellHelper *cellHelper;
@property (strong, nonatomic) ArrayHelper *arrayHelper;

- (IBAction)toggleEdit:(id)sender;
- (void) loadFavorites;

@end
