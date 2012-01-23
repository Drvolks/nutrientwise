//
//  FavoriteHelper.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodName.h"

@interface FavoriteHelper : NSObject

- (void) addToFavorite:(FoodName *) foodName;
- (NSMutableArray *) favotiteIds;
- (void) removeFavorite:(FoodName *) foodName;

@end
