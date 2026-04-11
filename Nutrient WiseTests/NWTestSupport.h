//
//  NWTestSupport.h
//  Nutrient WiseTests
//
//  Shared helpers for unit tests: in-memory Core Data stack,
//  fixture builders, NSUserDefaults scrubbing.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName;
@class NutritiveName;
@class NutritiveValue;
@class Measure;
@class ConversionFactor;

@interface NWTestSupport : NSObject

// Build a fresh in-memory NSManagedObjectContext using the compiled
// Model.mom from the host app bundle. Never touches DATA_v3.sqlite.
+ (NSManagedObjectContext *)newInMemoryContext;

// Wipe any NSUserDefaults keys the app cares about so tests start clean.
+ (void)resetUserDefaults;

// Fixture builders. All insert into the given context; caller is
// responsible for saving if persistence is needed.
+ (FoodName *)insertFoodWithId:(double)foodId
                   englishName:(NSString *)en
                    frenchName:(NSString *)fr
                     inContext:(NSManagedObjectContext *)ctx;

+ (NutritiveName *)insertNutritiveNameWithSymbol:(NSString *)symbol
                                     englishName:(NSString *)en
                                      frenchName:(NSString *)fr
                                            unit:(NSString *)unit
                                       inContext:(NSManagedObjectContext *)ctx;

+ (NutritiveValue *)insertNutritiveValue:(double)value
                                   name:(NutritiveName *)name
                                   food:(FoodName *)food
                              inContext:(NSManagedObjectContext *)ctx;

+ (Measure *)insertMeasureWithId:(double)measureId
                     englishName:(NSString *)en
                      frenchName:(NSString *)fr
                       inContext:(NSManagedObjectContext *)ctx;

+ (ConversionFactor *)insertConversionFactor:(double)factor
                                     measure:(Measure *)measure
                                        food:(FoodName *)food
                                   inContext:(NSManagedObjectContext *)ctx;

@end
