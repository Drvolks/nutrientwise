//
//  NutritiveValue.h
//  NutrientWiseImporter
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName, NutritiveName;

@interface NutritiveValue : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * nutritiveValue;
@property (nonatomic, retain) FoodName *foodName;
@property (nonatomic, retain) NutritiveName *nutritiveName;

@end
