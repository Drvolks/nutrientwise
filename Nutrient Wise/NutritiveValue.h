//
//  NutritiveValue.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName, NutritiveName, NutritiveSource;

@interface NutritiveValue : NSManagedObject

@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSNumber * nutritiveNameId;
@property (nonatomic, retain) NSNumber * nutritiveSourceId;
@property (nonatomic, retain) NSDecimalNumber * nutritiveValue;
@property (nonatomic, retain) FoodName *foodName;
@property (nonatomic, retain) NutritiveName *nutritiveName;
@property (nonatomic, retain) NutritiveSource *nutritiveSource;

@end
