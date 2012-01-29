//
//  NutritiveName.h
//  NutrientWiseImporter
//
//  Created by Jean-François Dufour on 12-01-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NutritiveName : NSManagedObject

@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSString * frenchName;
@property (nonatomic, retain) NSNumber * nutritiveNameId;
@property (nonatomic, retain) NSString * nutritiveSymbol;
@property (nonatomic, retain) NSString * unit;

@end
