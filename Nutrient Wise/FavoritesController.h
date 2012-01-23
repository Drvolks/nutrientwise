//
//  FavoritesController.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Finder.h"
#import "LanguageHelper.h"

@interface FavoritesController : UINavigationController

@property (strong, nonatomic) Finder *finder;
@property (strong, nonatomic) LanguageHelper *languageHelper;

@end
