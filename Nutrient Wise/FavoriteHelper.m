//
//  FavoriteHelper.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoriteHelper.h"

#define kFavorites @"favorites"
#define kFoodIdColumn @"foodId"
#define kDebug YES

@implementation FavoriteHelper

- (id) init {
    NSString *userDefaultsValuesPath=[[NSBundle mainBundle] pathForResource:@"UserPreferences" ofType:@"plist"];
    NSDictionary *userDefaultsValuesDict=[NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    
    // set them in the standard user defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
    
    return self;
}

- (void) addToFavorite:(FoodName *) foodName {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *favorites = [self favotiteIds];
    
    [favorites addObject:[foodName valueForKey:kFoodIdColumn]];
    [pref setObject:favorites forKey:kFavorites];
    
    if(kDebug) {
        NSLog(@"New favorite added. This is the new list: %@", [pref objectForKey:kFavorites]);
    }
}

- (NSMutableArray *) favotiteIds {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [pref objectForKey:kFavorites];
    NSMutableArray *newFavorites = [[NSMutableArray alloc] initWithArray:favorites];
    
    return newFavorites;
}

- (void) removeFavorite:(FoodName *) foodName {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *favorites = [self favotiteIds];
    
    [favorites removeObject:[foodName valueForKey:kFoodIdColumn]];
    [pref setObject:favorites forKey:kFavorites];
    
    if(kDebug) {
        NSLog(@"Favorite removed. This is the new list: %@", [pref objectForKey:kFavorites]);
    }   
}

@end
