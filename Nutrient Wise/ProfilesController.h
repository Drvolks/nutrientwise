//
//  ProfilesController.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"
#import "Finder.h"

@interface ProfilesController : UINavigationController

@property (strong, nonatomic) Finder *finder;
@property (strong, nonatomic) LanguageHelper *languageHelper;

@end
