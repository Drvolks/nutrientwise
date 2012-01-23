//
//  ProfileHelper.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileHelper.h"

#define kGenericProfile @"generic"
#define kRenalProfile @"rein"
#define kDiabeteProfile @"diabete"
#define kRenalProfileValues @""
#define kDiabeteProfileValues @""
#define kGenericProfileValues @"KCAL,FAT"

@implementation ProfileHelper

- (NSArray *) nutritiveSymbolsForProfile:(NSString *)profile {
    NSString *stringResult = kGenericProfileValues;
    
    if([profile isEqualToString:kRenalProfile]) {
        stringResult = kRenalProfileValues;
    } else if([profile isEqualToString:kDiabeteProfile]) {
        stringResult = kDiabeteProfileValues;
    }
    
    NSArray *result = [stringResult componentsSeparatedByString:@","];
    return result;
}

@end
