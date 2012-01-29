//
//  FavoriteHelper.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoriteHelper.h"
#import "Measure.h"

#define kFoodFavorites @"favorites"
#define kConversionFactorFavorites @"conversionFactors"
#define kFoodIdColumn @"foodId"
#define kMeasureIdColumn @"measureId"
#define kMeasureAttribute @"maesure"
#define kDebug YES

@implementation FavoriteHelper

- (id) init {
    NSString *userDefaultsValuesPath=[[NSBundle mainBundle] pathForResource:@"NutientWisePref" ofType:@"plist"];
    NSDictionary *userDefaultsValuesDict=[NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    
    // set them in the standard user defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
    
    return self;
}

- (void) addFoodToFavorite:(FoodName *) foodName {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *favorites = [self favotiteIds:kFoodFavorites];
    
    NSNumber *foodId = [foodName valueForKey:kFoodIdColumn];
    [favorites setObject:[foodName valueForKey:kFoodIdColumn] forKey:[foodId stringValue]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favorites];
    [pref setObject:data forKey:kFoodFavorites];
    
    if(kDebug) {
        NSLog(@"New favorite added. This is the new list: %@", [pref objectForKey:kFoodFavorites]);
    }
}

- (NSMutableDictionary *) favotiteIds:(NSString *) key {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSData *data = [pref objectForKey:key];
    NSMutableDictionary *favotites = nil;
    
    if(data != nil) {
        favotites = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    if(favotites == nil) {
        favotites = [[NSMutableDictionary alloc] init];
    }
    
    return favotites;
}

- (void) removeFavorite:(FoodName *) foodName {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *favorites = [self favotiteIds:kFoodFavorites];
    
    NSNumber *foodId = [foodName valueForKey:kFoodIdColumn];
    [favorites removeObjectForKey:[foodId stringValue]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favorites];
    [pref setObject:data forKey:kFoodFavorites];
    
    if(kDebug) {
        NSLog(@"Favorite removed. This is the new list: %@", [pref objectForKey:kFoodFavorites]);
    }   
}

- (BOOL) isFavorite:(FoodName *) foodName {
    NSMutableDictionary *favorites = [self favotiteIds:kFoodFavorites];

    NSNumber *foodId = [foodName valueForKey:kFoodIdColumn];
    NSNumber *result = [favorites valueForKey: [foodId stringValue]];
    if(result != nil) {
        if(kDebug) {
            NSLog(@"Food is a favorite");
        }
        return YES;
    }
    
    return NO;
}

- (void) addConversionToFavorite:(ConversionFactor *)conversionFactor:(FoodName *)foodName {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *favorites = [self favotiteIds:kConversionFactorFavorites];
    
    NSString *foodId = [[foodName valueForKey:kFoodIdColumn] stringValue];
    
    // remove old value
    if([favorites objectForKey:foodId] != nil) {
        [favorites removeObjectForKey:foodId];
    }
    
    Measure *measure = [conversionFactor valueForKey:kMeasureAttribute];
    [favorites setObject:[measure valueForKey:kMeasureIdColumn] forKey:foodId];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favorites];
    [pref setObject:data forKey:kConversionFactorFavorites];
    
    if(kDebug) {
        NSLog(@"New favorite conversion factor added. This is the new list: %@", [pref objectForKey:kConversionFactorFavorites]);
    }

}

- (NSNumber *) favoriteConversionMeasure:(FoodName *) foodName {
    NSMutableDictionary *favorites = [self favotiteIds:kConversionFactorFavorites];
    
    NSNumber *foodId = [foodName valueForKey:kFoodIdColumn];
    NSNumber *result = [favorites valueForKey: [foodId stringValue]];
    
    if(kDebug) {
        NSLog(@"Favorite conversion factor (measure) is %@", result);
    }
    
    return result;
}

- (NSMutableDictionary *) favotiteFoodIds {
    return [self favotiteIds:kFoodFavorites];
}

@end
