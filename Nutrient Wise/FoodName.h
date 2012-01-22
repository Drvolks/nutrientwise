//
//  FoodName.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConversionFactor, FoodSource, GroupName, NutritiveValue, Refuse, Yield;

@interface FoodName : NSManagedObject

@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSNumber * foodCode;
@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSNumber * foodSourceId;
@property (nonatomic, retain) NSString * frenchName;
@property (nonatomic, retain) NSNumber * groupNameId;
@property (nonatomic, retain) NSSet *conversionFactors;
@property (nonatomic, retain) FoodSource *foodSource;
@property (nonatomic, retain) GroupName *groupName;
@property (nonatomic, retain) NSSet *nutritiveValues;
@property (nonatomic, retain) NSSet *refuses;
@property (nonatomic, retain) NSSet *yields;
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

- (void)addRefusesObject:(Refuse *)value;
- (void)removeRefusesObject:(Refuse *)value;
- (void)addRefuses:(NSSet *)values;
- (void)removeRefuses:(NSSet *)values;

- (void)addYieldsObject:(Yield *)value;
- (void)removeYieldsObject:(Yield *)value;
- (void)addYields:(NSSet *)values;
- (void)removeYields:(NSSet *)values;

@end
