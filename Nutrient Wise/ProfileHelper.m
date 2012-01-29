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
#define kRenalProfileValues @"PROT,H2O,K,P,NA,MG"
#define kDiabeteProfileValues @""
#define kGenericProfileValues @"KCAL,FAT"
#define kProfileSetting @"profile"

@implementation ProfileHelper

- (id) init {
    return self;
}

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

- (NSString *) selectedProfile {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *language = [settings objectForKey:kProfileSetting];
    
    return language;
}

- (void) setSelectedProfile:(NSString *) profile {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:profile forKey:kProfileSetting];
    [settings synchronize];
}

- (NSArray *) supportedProfiles {
    NSMutableArray *profiles = [[NSMutableArray alloc] initWithCapacity:3];
    [profiles addObject:kGenericProfile];
    [profiles addObject:kRenalProfile];
    [profiles addObject:kDiabeteProfile];
    
    return profiles;
}

- (BOOL) genericProfileSelected {
    NSString *profile = [self selectedProfile];
    return [kGenericProfile isEqualToString:profile];
}

- (NSString *) genericProfileKey {
    return kGenericProfile;
}

@end
