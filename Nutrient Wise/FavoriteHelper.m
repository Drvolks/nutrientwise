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
    
    NSArray *favorites = [pref objectForKey:kFavorites];
    NSMutableArray *newFavorites = [[NSMutableArray alloc] initWithArray:favorites];
    
    [newFavorites addObject:[foodName valueForKey:kFoodIdColumn]];
    
    [pref setObject:newFavorites forKey:kFavorites];
    [pref synchronize];
    
    NSLog(@"2 = %@", [pref objectForKey:kFavorites]);
}

- (NSArray *) favotiteIds {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [pref objectForKey:kFavorites];
    
    return favorites;
}

@end
