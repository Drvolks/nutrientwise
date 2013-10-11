//
//  FavoriteActivity.m
//  Nutrient Wise
//
//  Created by Jean-François on 2013-10-11.
//
//

#import "FavoriteActivity.h"

#define kImageNotFavorite @"709-plus.png"
#define kImageFavorite @"709-minus.png"
#define kTextAddFavorite @"addFavorite"
#define kTextRemoveFavorite @"removeFavorite"

@implementation FavoriteActivity

@synthesize foodName;
@synthesize favoriteHelper;
@synthesize languageHelper;

- (id) initWithFood:(FoodName*)pFoodName {
    foodName = pFoodName;
    
    favoriteHelper = [FavoriteHelper sharedInstance];
    languageHelper = [LanguageHelper sharedInstance];
    
    return self;
}

- (NSString *)activityType {
    return @"favorite";
}

- (NSString *)activityTitle {
    BOOL isFavorite = [favoriteHelper isFavorite:foodName];
    NSString *text = kTextAddFavorite;
    if(isFavorite) {
        text = kTextRemoveFavorite;
    }
    
    return [languageHelper localizedString:text];
}

- (UIImage *)activityImage {
    BOOL isFavorite = [favoriteHelper isFavorite:foodName];
    NSString *image = kImageNotFavorite;
    if(isFavorite) {
        image = kImageFavorite;
    }
    
    return [UIImage imageNamed:image];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (UIViewController *)activityViewController {
    return nil;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {

}

-(void)performActivity {
    if([favoriteHelper isFavorite:foodName])
    {
        [favoriteHelper removeFavorite:foodName];
    } else {
        [favoriteHelper addFoodToFavorite:foodName];
    }
    
    [self activityDidFinish:YES];
}
@end
