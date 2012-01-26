//
//  Language.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageHelper : NSObject

- (BOOL) french;
- (NSString *) nameColumn;
- (NSString *) localizedString:(NSString *)key;

@end
