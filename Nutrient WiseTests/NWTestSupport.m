//
//  NWTestSupport.m
//  Nutrient WiseTests
//

#import "NWTestSupport.h"
#import "FoodName.h"
#import "NutritiveName.h"
#import "NutritiveValue.h"
#import "Measure.h"
#import "ConversionFactor.h"

@implementation NWTestSupport

+ (NSManagedObjectContext *)newInMemoryContext {
    // Prefer the merged model so we pick up whatever the host app's
    // Model.mom/.momd was compiled to, without hardcoding a filename.
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    if (model == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"mom"];
        if (url == nil) {
            url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        }
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    }

    NSPersistentStoreCoordinator *coordinator =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType
                              configuration:nil
                                        URL:nil
                                    options:nil
                                      error:&error];
    NSAssert(error == nil, @"Failed to add in-memory store: %@", error);

    NSManagedObjectContext *ctx =
        [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    ctx.persistentStoreCoordinator = coordinator;
    return ctx;
}

+ (void)resetUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"language"];
    [defaults removeObjectForKey:@"profile"];
    [defaults removeObjectForKey:@"favorites"];
    [defaults removeObjectForKey:@"conversionFactors"];
    [defaults synchronize];
}

+ (FoodName *)insertFoodWithId:(double)foodId
                   englishName:(NSString *)en
                    frenchName:(NSString *)fr
                     inContext:(NSManagedObjectContext *)ctx {
    FoodName *food = [NSEntityDescription insertNewObjectForEntityForName:@"FoodName"
                                                   inManagedObjectContext:ctx];
    [food setValue:@(foodId) forKey:@"foodId"];
    [food setValue:en forKey:@"englishName"];
    [food setValue:fr forKey:@"frenchName"];
    return food;
}

+ (NutritiveName *)insertNutritiveNameWithSymbol:(NSString *)symbol
                                     englishName:(NSString *)en
                                      frenchName:(NSString *)fr
                                            unit:(NSString *)unit
                                       inContext:(NSManagedObjectContext *)ctx {
    NutritiveName *n = [NSEntityDescription insertNewObjectForEntityForName:@"NutritiveName"
                                                     inManagedObjectContext:ctx];
    [n setValue:symbol forKey:@"nutritiveSymbol"];
    [n setValue:en forKey:@"englishName"];
    [n setValue:fr forKey:@"frenchName"];
    [n setValue:unit forKey:@"unit"];
    return n;
}

+ (NutritiveValue *)insertNutritiveValue:(double)value
                                    name:(NutritiveName *)name
                                    food:(FoodName *)food
                               inContext:(NSManagedObjectContext *)ctx {
    NutritiveValue *nv = [NSEntityDescription insertNewObjectForEntityForName:@"NutritiveValue"
                                                       inManagedObjectContext:ctx];
    [nv setValue:[NSDecimalNumber numberWithDouble:value] forKey:@"nutritiveValue"];
    [nv setValue:name forKey:@"nutritiveName"];
    [nv setValue:food forKey:@"foodName"];
    return nv;
}

+ (Measure *)insertMeasureWithId:(double)measureId
                     englishName:(NSString *)en
                      frenchName:(NSString *)fr
                       inContext:(NSManagedObjectContext *)ctx {
    Measure *m = [NSEntityDescription insertNewObjectForEntityForName:@"Measure"
                                               inManagedObjectContext:ctx];
    [m setValue:@(measureId) forKey:@"measureId"];
    [m setValue:en forKey:@"englishName"];
    [m setValue:fr forKey:@"frenchName"];
    return m;
}

+ (ConversionFactor *)insertConversionFactor:(double)factor
                                     measure:(Measure *)measure
                                        food:(FoodName *)food
                                   inContext:(NSManagedObjectContext *)ctx {
    ConversionFactor *cf = [NSEntityDescription insertNewObjectForEntityForName:@"ConversionFactor"
                                                         inManagedObjectContext:ctx];
    [cf setValue:[NSDecimalNumber numberWithDouble:factor] forKey:@"conversionFactor"];
    [cf setValue:measure forKey:@"maesure"];
    [cf setValue:food forKey:@"foodName"];
    return cf;
}

@end
