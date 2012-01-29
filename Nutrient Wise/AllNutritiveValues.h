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
<<<<<<< HEAD
#import "ArrayHelper.h"
=======
#import "CellHelper.h"
>>>>>>> 2978de6146a4258e1a773264ca58e244346d0472

@interface AllNutritiveValues : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FoodName *foodName;
@property (strong, nonatomic) NSArray *nutritiveValues;
@property (strong, nonatomic) ConversionFactor *selectedConversionFactor;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) ArrayHelper *arrayHelper;
@property (nonatomic) BOOL *cellNibLoaded;
@property (strong, nonatomic) CellHelper *cellHelper;

- (id) initWithFoodName:(FoodName *) food:(ConversionFactor *) conversionFactor;

@end
