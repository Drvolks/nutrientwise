//
//  FoodName.h
//  NutrientWiseImporter
//
//  Created by Jean-François Dufour on 12-01-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConversionFactor, NutritiveValue;

@interface FoodName : NSManagedObject

@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSString * frenchName;
@property (nonatomic, retain) NSSet *conversionFactors;
@property (nonatomic, retain) NSSet *nutritiveValues;
@end

@interface FoodName (CoreDataGeneratedAccessors)

- (void)addConversionFactorsObject:(ConversionFactor *)value;
- (void)removeConversionFactorsObject:(ConversionFactor *)value;
- (void)addConversionFactors:(NSSet *)values;
- (void)removeConversionFactors:(NSSet *)values;

- (void)addNutritiveValuesObject:(NutritiveValue *)value;
- (void)removeNutritiveValuesObject:(NutritiveValue *)value;
- (void)addNutritiveValues:(NSSet *)values;
- (void)removeNutritiveValues:(NSSet *)values;

@end
