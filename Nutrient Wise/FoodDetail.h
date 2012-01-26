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

@interface FoodDetail : UIViewController  <UITableViewDelegate, UITableViewDataSource, MeasureSelectionDelegate>

@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) FoodName *food;
@property (strong, nonatomic) NSArray *nutritiveValues;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) ProfileHelper *profileHelper;
@property (strong, nonatomic) FavoriteHelper *favoriteHelper;
@property (strong, nonatomic) ConversionFactor *selectedConversionFactor;

- (id)initWithFood:(FoodName *)foodEntity;
- (NSArray *) nutritiveValueKeys;
- (NSArray *) nutritiveValues:(NSArray *)keys;
- (void) prepareDisplay;

@end
