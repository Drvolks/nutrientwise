//
//  NutientValueCellHelper.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NutientValueCell.h"
#import "LanguageHelper.h"
#import "ConversionFactor.h"

@interface NutientValueCellHelper : NSObject

@property (strong, nonatomic) LanguageHelper *languageHelper;

- (NutientValueCell *) makeCell:(UITableView *) table:(NSString *) rowIdentifier:(NSArray *) nutritiveValues:(NSIndexPath *) indexPath:(ConversionFactor *) conversionFactor;

@end
