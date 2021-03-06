//
//  FavoriteHelper.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodName.h"
#import "ConversionFactor.h"

@interface FavoriteHelper : NSObject

+ (id) sharedInstance;
- (id) init;
- (void) addFoodToFavorite:(FoodName *) foodName;
- (NSMutableDictionary *) favotiteIds:(NSString *) key;
- (NSMutableDictionary *) favotiteFoodIds;
- (void) removeFavorite:(FoodName *) foodName;
- (BOOL) isFavorite:(FoodName *) foodName;
- (void) addConversionToFavorite:(ConversionFactor *)conversionFactor
                                foodName:(FoodName *)foodName;
- (NSNumber *) favoriteConversionMeasure:(FoodName *) foodName;

@end
