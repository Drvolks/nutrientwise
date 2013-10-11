//
//  FavoriteActivity.h
//  Nutrient Wise
//
//  Created by Jean-François on 2013-10-11.
//
//

#import <UIKit/UIKit.h>
#import "FoodName.h"
#import "FavoriteHelper.h"
#import "LanguageHelper.h"

@interface FavoriteActivity : UIActivity

@property (strong, nonatomic) FoodName *foodName;
@property (strong, nonatomic) FavoriteHelper *favoriteHelper;
@property (strong, nonatomic) LanguageHelper *languageHelper;

- (id) initWithFood:(FoodName*)pFoodName;

@end
