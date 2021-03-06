//
//  AllNutritiveValues.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodName.h"
#import "ConversionFactor.h"
#import "LanguageHelper.h"
#import "ArrayHelper.h"
#import "CellHelper.h"

@interface AllNutritiveValues : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FoodName *foodName;
@property (strong, nonatomic) NSArray *nutritiveValues;
@property (strong, nonatomic) NSMutableDictionary *nutritiveValuesIndex;
@property (strong, nonatomic) ConversionFactor *selectedConversionFactor;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) ArrayHelper *arrayHelper;
@property (strong, nonatomic) CellHelper *cellHelper;
@property (strong, nonatomic) NSMutableArray *keys;

- (id) initWithFoodName:(FoodName *) food
                       conversionFactor:(ConversionFactor *) conversionFactor;
- (void) buildIndex;
- (NSString*) decomposeAndFilterString:(NSString*) string;

@end
