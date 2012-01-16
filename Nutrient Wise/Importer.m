#import "Importer.h"
#import "FoodName.h"
#import "NutritiveValue.h"
#import "ConversionFactor.h"
#import "FoodSource.h"
#import "Yield.h"
#import "YieldName.h"
#import "NutritiveName.h"
#import "NutritiveSource.h"
#import "Refuse.h"
#import "RefuseName.h"
#import "Measure.h"
#import "GroupName.h"

@implementation Importer

@synthesize managedObjectContext;
@synthesize formatterInteger;
@synthesize formatterDecimal;
@synthesize finder;

- (id)initWithContext:(NSManagedObjectContext *)mObjectContext {
    self.managedObjectContext = mObjectContext;
    
    self.formatterInteger = [[NSNumberFormatter alloc] init];
    [self.formatterInteger setNumberStyle:NSNumberFormatterNoStyle];
    
    self.formatterDecimal = [[NSNumberFormatter alloc] init];
    [self.formatterDecimal setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.finder = [[Finder alloc] initWithContext:mObjectContext];
    
    return self;
}

- (void)importData
{
    NSArray *refuseNames = [self loadFile:@"REFU_NM"];
    [self processRefuseName:refuseNames];
    
    NSArray *yieldNames = [self loadFile:@"YLD_NM"];
    [self processYieldName:yieldNames];
    
    NSArray *groupNames = [self loadFile:@"FOOD_GRP"];
    [self processGroupName:groupNames];
    
    NSArray *foodSources = [self loadFile:@"FOOD_SRC"];
    [self processFoodSource:foodSources];
    
    NSArray *mesures = [self loadFile:@"MEASURE"];
    [self processMesure:mesures];
    
    NSArray *foodNameLines = [self loadFile:@"FOOD_NM"];
    [self processFoodName:foodNameLines];
    
    NSArray *yields = [self loadFile:@"YIELD"];
    [self processYield:yields];
    
    NSArray *refuses = [self loadFile:@"REFUSE"];
    [self processRefuse:refuses];
    
    NSArray *conversionFactors = [self loadFile:@"CONV_FAC"];
    [self processConversionFactor:conversionFactors];
    
    NSArray *nutritiveNames = [self loadFile:@"NT_NM"];
    [self processNutritiveName:nutritiveNames];
    
    NSArray *nutritiveSources = [self loadFile:@"NT_SRC"];
    [self processNutritiveSource:nutritiveSources];
    
    NSArray *nutritiveValueLines = [self loadFile:@"NT_AMT"];
    [self processNutritiveValue:nutritiveValueLines];
    
    
    
    
} 

- (NSArray *) loadFile:(NSString *) fileName {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:fileName ofType:@"txt"];  
   
    NSError *error;
    NSString* content = [NSString stringWithContentsOfFile:filePath encoding:NSISOLatin1StringEncoding error:&error];
    
    NSArray *result = [content componentsSeparatedByString: @"\n"];
    NSMutableArray *mutableArray = [result mutableCopy];
    
    // removing header line
    [mutableArray removeObjectAtIndex:0]; 
    
    return mutableArray;
}

- (void) processFoodName:(NSArray *) list
{    
    for(id foodNameLine in list) {
        NSArray *content = [foodNameLine componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 12) {
            NSString *foodId = [content objectAtIndex:0];
            NSString *foodCode = [content objectAtIndex:1];
            NSString *foodGroupId = [content objectAtIndex:2];
            NSString *foodSourceId = [content objectAtIndex:3];
            NSString *longNameEnglish = [content objectAtIndex:6];
            NSString *longNameFrench = [content objectAtIndex:7];
           
            FoodName *foodNameEntity = (FoodName *)[NSEntityDescription insertNewObjectForEntityForName:@"FoodName" inManagedObjectContext:managedObjectContext];
            [foodNameEntity setFoodId:[formatterInteger numberFromString:foodId]];
            [foodNameEntity setFoodCode:[formatterInteger numberFromString:foodCode]];
            [foodNameEntity setGroupNameId:[formatterInteger numberFromString:foodGroupId]];
            [foodNameEntity setFoodSourceId:[formatterInteger numberFromString:foodSourceId]];
            [foodNameEntity setEnglishName:longNameEnglish];
            [foodNameEntity setFrenchName:longNameFrench];
            
            FoodSource *foodSource = [finder getFoodSource:[formatterInteger numberFromString:foodSourceId]];
            if(foodSource != nil) {
                [foodNameEntity setFoodSource:foodSource];
            } else {
                NSLog(@"FoodSource not found with id %@ for entity FoodName", foodSourceId);
            }
            
            GroupName *groupName = [finder getGroupName:[formatterInteger numberFromString:foodGroupId]];
            if(groupName != nil) {
                [foodNameEntity setGroupName:groupName];
            } else {
                NSLog(@"GroupName not found with id %@ for entity FoodName", foodGroupId);
            }
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
            
            //NSLog(@"%@\n", foodId);
            //if([foodId compare:@"4"] == NSOrderedSame) return;
        }
        else {
            NSLog(@"FoodNameLine does not have 12 elements");
        }
    }
}

- (void) processNutritiveValue:(NSArray *) list
{
    for(id nutrientValueLine in list) {
        NSArray *content = [nutrientValueLine componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 8) {
            NSString *foodId = [content objectAtIndex:0];
            NSString *nutritiveNameId = [content objectAtIndex:1];
            NSString *nutrientValue = [content objectAtIndex:2];
            NSString *nutritiveSourceId = [content objectAtIndex:5];
            
            NutritiveValue *nutritiveValueEntity = (NutritiveValue *)[NSEntityDescription insertNewObjectForEntityForName:@"NutritiveValue" inManagedObjectContext:managedObjectContext];
            [nutritiveValueEntity setFoodId:[formatterInteger numberFromString:foodId]];
            [nutritiveValueEntity setNutritiveNameId:[formatterInteger numberFromString:nutritiveNameId]];
            [nutritiveValueEntity setNutritiveValue:[formatterDecimal numberFromString:nutrientValue]];
            [nutritiveValueEntity setNutritiveSourceId:[formatterInteger numberFromString:nutritiveSourceId]];
            
            FoodName *foodName = [finder getFoodName:[formatterInteger numberFromString:foodId]];
            if(foodName != nil) {
                [nutritiveValueEntity setFoodName:foodName];
            } else {
                NSLog(@"FoodName not found with id %@ for entity NutritiveValue", foodId);
            }
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
            
            //NSLog(@"%@\n", nutrientValueLine);
            //if([foodId compare:@"4"] == NSOrderedSame) return;
        }
        else {
            NSLog(@"NutritiveValueLine does not have 8 elements");
        }
    }
}

- (void) processConversionFactor:(NSArray *) list{
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 4) {
            NSString *foodId = [content objectAtIndex:0];
            NSString *measureId = [content objectAtIndex:1];
            NSString *conversionFactor = [content objectAtIndex:2];
            
            ConversionFactor *conversionFactorEntity = (ConversionFactor *)[NSEntityDescription insertNewObjectForEntityForName:@"ConversionFactor" inManagedObjectContext:managedObjectContext];
            [conversionFactorEntity setFoodId:[formatterInteger numberFromString:foodId]];
            [conversionFactorEntity setMeasureId:[formatterInteger numberFromString:measureId]];
            [conversionFactorEntity setConversionFactor:[formatterDecimal numberFromString:conversionFactor]];
            
            FoodName *foodName = [finder getFoodName:[formatterInteger numberFromString:foodId]];
            if(foodName != nil) {
                [conversionFactorEntity setFoodName:foodName];
            } else {
                NSLog(@"FoodName not found with id %@ for entity NutritiveValue", foodId);
            }
            
            Measure *measure = [finder getMeasure:[formatterInteger numberFromString:measureId]];
            if(measure != nil) {
                [conversionFactorEntity setMaesure:measure];
            } else {
                NSLog(@"Measure not found with id %@ for entity ConversionFactor", measureId);
            }
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"ConversionFactor line does not have 4 elements");
        }
    }

}

- (void) processFoodSource:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 4) {
            NSString *foodSourceId = [content objectAtIndex:0];
            NSString *foodSourceCode = [content objectAtIndex:1];
            NSString *englishName = [content objectAtIndex:2];
            NSString *frenchName = [content objectAtIndex:3];
            
            FoodSource *foodSourceEntity = (FoodSource *)[NSEntityDescription insertNewObjectForEntityForName:@"FoodSource" inManagedObjectContext:managedObjectContext];
            [foodSourceEntity setFoodSourceId:[formatterInteger numberFromString:foodSourceId]];
            [foodSourceEntity setFoodSourceCode:[formatterInteger numberFromString:foodSourceCode]];
            [foodSourceEntity setEnglishName:englishName];
            [foodSourceEntity setFrenchName:frenchName];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"FoodSource line does not have 4 elements");
        }
    }
}

- (void) processGroupName:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 4) {
            NSString *groupNameId = [content objectAtIndex:0];
            NSString *groupNameCode = [content objectAtIndex:1];
            NSString *englishName = [content objectAtIndex:2];
            NSString *frenchName = [content objectAtIndex:3];
            
            GroupName *groupNameEntity = (GroupName *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupName" inManagedObjectContext:managedObjectContext];
            [groupNameEntity setGroupNameId:[formatterInteger numberFromString:groupNameId]];
            [groupNameEntity setGroupNameCode:[formatterInteger numberFromString:groupNameCode]];
            [groupNameEntity setEnglishName:englishName];
            [groupNameEntity setFrenchName:frenchName];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"GroupName line does not have 4 elements");
        }
    }
}

- (void) processMesure:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 3) {
            NSString *measureId = [content objectAtIndex:0];
            NSString *englishName = [content objectAtIndex:1];
            NSString *frenchName = [content objectAtIndex:2];
            
            Measure *measureEntity = (Measure *)[NSEntityDescription insertNewObjectForEntityForName:@"Measure" inManagedObjectContext:managedObjectContext];
            [measureEntity setMeasureId:[formatterInteger numberFromString:measureId]];
            [measureEntity setEnglishName:englishName];
            [measureEntity setFrenchName:frenchName];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"Measure line does not have 3 elements");
        }
    }
}

- (void) processNutritiveName:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 8) {
            NSString *nutritiveNameId = [content objectAtIndex:0];
            NSString *nutritiveNameCode = [content objectAtIndex:1];
            NSString *nutritiveSymbol = [content objectAtIndex:2];
            NSString *unit = [content objectAtIndex:3];
            NSString *englishName = [content objectAtIndex:4];
            NSString *frenchName = [content objectAtIndex:5];
            
            NutritiveName *nutritiveNameEntity = (NutritiveName *)[NSEntityDescription insertNewObjectForEntityForName:@"NutritiveName" inManagedObjectContext:managedObjectContext];
            [nutritiveNameEntity setNutritiveNameId:[formatterInteger numberFromString:nutritiveNameId]];
            [nutritiveNameEntity setNutritiveNameCode:[formatterInteger numberFromString:nutritiveNameCode]];
            [nutritiveNameEntity setNutritiveSymbol:nutritiveSymbol];
            [nutritiveNameEntity setUnit:unit];
            [nutritiveNameEntity setEnglishName:englishName];
            [nutritiveNameEntity setFrenchName:frenchName];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"NutritiveName line does not have 8 elements");
        }
    }
}

- (void) processNutritiveSource:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 4) {
            NSString *nutritiveSourceId = [content objectAtIndex:0];
            NSString *nutritiveSourceCode = [content objectAtIndex:1];
            NSString *englishName = [content objectAtIndex:2];
            NSString *frenchName = [content objectAtIndex:3];
            
            NutritiveSource *nutritiveSourceEntity = (NutritiveSource *)[NSEntityDescription insertNewObjectForEntityForName:@"NutritiveSource" inManagedObjectContext:managedObjectContext];
            [nutritiveSourceEntity setNutritiveSourceId:[formatterInteger numberFromString:nutritiveSourceId]];
            [nutritiveSourceEntity setNutritiveSourceCode:[formatterInteger numberFromString:nutritiveSourceCode]];
            [nutritiveSourceEntity setEnglishName:englishName];
            [nutritiveSourceEntity setFrenchName:frenchName];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"NutritiveSource line does not have 4 elements");
        }
    }
}

- (void) processRefuse:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 4) {
            NSString *foodId = [content objectAtIndex:0];
            NSString *refuseNameId = [content objectAtIndex:1];
            NSString *refuseAmount = [content objectAtIndex:2];
            
            Refuse *refuseEntity = (Refuse *)[NSEntityDescription insertNewObjectForEntityForName:@"Refuse" inManagedObjectContext:managedObjectContext];
            [refuseEntity setFoodId:[formatterInteger numberFromString:foodId]];
            [refuseEntity setRefuseNameId:[formatterInteger numberFromString:refuseNameId]];
            [refuseEntity setRefuseAmount:[formatterDecimal numberFromString:refuseAmount]];
            
            FoodName *foodName = [finder getFoodName:[formatterInteger numberFromString:foodId]];
            if(foodName != nil) {
                [refuseEntity setFoodName:foodName];
            } else {
                NSLog(@"FoodName not found with id %@ for entity Refuse", foodId);
            }
            
            RefuseName *refuseName = [finder getRefuseName:[formatterInteger numberFromString:refuseNameId]];
            if(refuseName != nil) {
                [refuseEntity setRefuseName:refuseName];
            } else {
                NSLog(@"RefuseName not found with id %@ for entity Refuse", refuseNameId);
            }
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"Refuse line does not have 4 elements");
        }
    }
}

- (void) processRefuseName:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 3) {
            NSString *refuseNameId = [content objectAtIndex:0];
            NSString *englishName = [content objectAtIndex:1];
            NSString *frenchName = [content objectAtIndex:2];
            
            RefuseName *refuseNameEntity = (RefuseName *)[NSEntityDescription insertNewObjectForEntityForName:@"RefuseName" inManagedObjectContext:managedObjectContext];
            [refuseNameEntity setRefuseNameId:[formatterInteger numberFromString:refuseNameId]];
            [refuseNameEntity setEnglishName:englishName];
            [refuseNameEntity setFrenchName:frenchName];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"RefuseName line does not have 3 elements, it says %d", elementCount);
            NSLog(@"Line example: %@", line);
        }
    }
}

- (void) processYield:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 4) {
            NSString *foodId = [content objectAtIndex:0];
            NSString *yieldNameId = [content objectAtIndex:1];
            NSString *yieldAmount = [content objectAtIndex:2];
            
            Yield *yieldEntity = (Yield *)[NSEntityDescription insertNewObjectForEntityForName:@"Yield" inManagedObjectContext:managedObjectContext];
            [yieldEntity setFoodId:[formatterInteger numberFromString:foodId]];
            [yieldEntity setYieldNameId:[formatterInteger numberFromString:yieldNameId]];
            [yieldEntity setYieldAmount:[formatterDecimal numberFromString:yieldAmount]];
            
            FoodName *foodName = [finder getFoodName:[formatterInteger numberFromString:foodId]];
            if(foodName != nil) {
                [yieldEntity setFoodName:foodName];
            } else {
                NSLog(@"FoodName not found with id %@ for entity Yield", foodId);
            }
            
            YieldName *yieldName = [finder getYieldName:[formatterInteger numberFromString:yieldNameId]];
            if(yieldName != nil) {
                [yieldEntity setYieldName:yieldName];
            } else {
                NSLog(@"YieldName not found with id %@ for entity Yield", yieldNameId);
            }
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"Refuse line does not have 4 elements");
        }
    }

}

- (void) processYieldName:(NSArray *) list {
    for(id line in list) {
        NSArray *content = [line componentsSeparatedByString:@"$"];
        
        NSUInteger elementCount = [content count];
        if(elementCount == 3) {
            NSString *yieldNameId = [content objectAtIndex:0];
            NSString *englishName = [content objectAtIndex:1];
            NSString *frenchName = [content objectAtIndex:2];
            
            YieldName *yieldNameEntity = (YieldName *)[NSEntityDescription insertNewObjectForEntityForName:@"YieldName" inManagedObjectContext:managedObjectContext];
            [yieldNameEntity setYieldNameId:[formatterInteger numberFromString:yieldNameId]];
            [yieldNameEntity setEnglishName:englishName];
            [yieldNameEntity setFrenchName:frenchName];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }
        else {
            NSLog(@"YieldName line does not have 3 elements");
        }
    }
}

@end

