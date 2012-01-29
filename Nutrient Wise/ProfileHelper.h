//
//  ProfileHelper.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileHelper : NSObject

- (NSArray *) nutritiveSymbolsForProfile:(NSString *)profile;
- (NSString *) selectedProfile;
- (void) setSelectedProfile:(NSString *) profile;
- (NSArray *) supportedProfiles;

@end
