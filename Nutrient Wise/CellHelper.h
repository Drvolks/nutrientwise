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
- (UITableViewCell *) makeNutientValueCell:(UITableView *) table:(NSString *) rowIdentifier:(NSArray *) nutritiveValues:(NSIndexPath *) indexPath:(ConversionFactor *) conversionFactor;
- (UITableViewCell *) makeFoodNameCell:(UITableView *) table:(NSString *)rowIdentifier:(NSIndexPath *)indexPath:(NSArray *) searchResults;

@end
