//
//  FoodName.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-12.
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
@property (nonatomic, retain) ConversionFactor *conversionFactors;
@property (nonatomic, retain) FoodSource *foudSource;
@property (nonatomic, retain) GroupName *groupName;
@property (nonatomic, retain) NSSet *nutritiveValues;
@property (nonatomic, retain) Refuse *refuses;
@property (nonatomic, retain) Yield *yields;
@end

@interface FoodName (CoreDataGeneratedAccessors)

- (void)addNutritiveValuesObject:(NutritiveValue *)value;
- (void)removeNutritiveValuesObject:(NutritiveValue *)value;
- (void)addNutritiveValues:(NSSet *)values;
- (void)removeNutritiveValues:(NSSet *)values;

@end
