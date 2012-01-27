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

@interface AllNutritiveValues : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FoodName *foodName;
@property (strong, nonatomic) NSArray *nutritiveValues;
@property (strong, nonatomic) ConversionFactor *selectedConversionFactor;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (nonatomic) BOOL *cellNibLoaded;

- (id) initWithFoodName:(FoodName *) food:(ConversionFactor *) conversionFactor;

@end
