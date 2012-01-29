//
//  About.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"

@interface About : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *about;
@property (strong, nonatomic) LanguageHelper *languageHelper;

@end
