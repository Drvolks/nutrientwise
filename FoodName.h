//
//  FoodName.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NutritiveValue;

@interface FoodName : NSManagedObject

@property (nonatomic, retain) NSNumber * foodCode;
@property (nonatomic, retain) NSNumber * foodGroupId;
@property (nonatomic, retain) NSNumber * foodSourceId;
@property (nonatomic, retain) NSString * longNameEnglish;
@property (nonatomic, retain) NSString * longNameFrench;
@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSSet *nutritiveValues;
@end

@interface FoodName (CoreDataGeneratedAccessors)

- (void)addNutritiveValuesObject:(NutritiveValue *)value;
- (void)removeNutritiveValuesObject:(NutritiveValue *)value;
- (void)addNutritiveValues:(NSSet *)values;
- (void)removeNutritiveValues:(NSSet *)values;

@end
