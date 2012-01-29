//
//  FoodDetail.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodName.h"
#import "LanguageHelper.h"
#import "ProfileHelper.h"
#import "FavoriteHelper.h"
#import "ConversionFactor.h"
#import "MeasureSelection.h"
#import "CellHelper.h"

@interface FoodDetail : UIViewController  <UITableViewDelegate, UITableViewDataSource, MeasureSelectionDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) FoodName *foodName;
@property (strong, nonatomic) NSArray *nutritiveValues;
@property (strong, nonatomic) NSArray *genericValues;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) ProfileHelper *profileHelper;
@property (strong, nonatomic) FavoriteHelper *favoriteHelper;
@property (strong, nonatomic) ConversionFactor *selectedConversionFactor;
@property (nonatomic) BOOL *cellNibLoaded;
@property (strong, nonatomic) CellHelper *cellHelper;

- (id)initWithFood:(FoodName *)foodEntity;
- (NSArray *) nutritiveValueKeys:(NSString *) profile;
- (NSArray *) nutritiveValues:(NSArray *)keys;
- (void) prepareDisplay;
- (NSArray *) cleanGenericValues:(NSArray *) allKeys;

@end
