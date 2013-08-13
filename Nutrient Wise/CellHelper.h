//
//  NutientValueCellHelper.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguageHelper.h"
#import "ConversionFactor.h"
#import "FoodName.h"

@interface CellHelper : NSObject

@property (strong, nonatomic) LanguageHelper *languageHelper;

+ (id) sharedInstance;
- (UITableViewCell *) makeNutientValueCell:(UITableView *) table
                             rowIdentifier:(NSString *) rowIdentifier
                             nutritiveValues:(NSArray *) nutritiveValues
                             indexPath:(NSIndexPath *) indexPath
                             conversionFactor:(ConversionFactor *) conversionFactor
                             avecIndex:(BOOL)avecIndex;
- (UITableViewCell *) makeFoodNameCell:(UITableView *) table
                             rowIdentifier:(NSString *)rowIdentifier
                             indexPath:(NSIndexPath *)indexPath
                             searchResults:(NSArray *) searchResults;
- (NSString *) nutrientNameForRow:(NSIndexPath *)indexPath
        nutritiveValues:(NSArray *) nutritiveValues;

@end
