//
//  ProfileSelection.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"
#import "ProfileHelper.h"

@protocol ProfileSelectionDelegate <NSObject>
- (void) profileSelected:(NSString *) profile;
@end

@interface ProfileSelection : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id) initWithProfile:(NSString *)pSelectedProfile;

@property (strong, nonatomic) NSArray *profiles;
@property (strong, nonatomic) NSString *selectedProfile;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (nonatomic, assign) id  <ProfileSelectionDelegate> delegate;  
@property (strong, nonatomic) ProfileHelper *profileHelper;

@end
