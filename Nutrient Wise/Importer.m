#import "Importer.h"
#import "FoodName.h"
#import "NutritiveValue.h"

@implementation Importer

@synthesize managedObjectContext;
@synthesize formatter;
@synthesize finder;

- (id)initWithContext:(NSManagedObjectContext *)mObjectContext {
    self.managedObjectContext = mObjectContext;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    [self.formatter setNumberStyle:NSNumberFormatterNoStyle];
    
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
    
    
    
    //NSNumber *number = [[NSNumber alloc] initWithInt:2];
    //FoodName *name = [finder getFoodName:number];
    //NSSet *set = [name valueForKey:@"nutritiveValues"];
    //NSLog(@"FoodName 2 has %d nutrients", [set count]);
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
            [foodNameEntity setFoodId:[formatter numberFromString:foodId]];
            [foodNameEntity setFoodCode:[formatter numberFromString:foodCode]];
            [foodNameEntity setGroupNameId:[formatter numberFromString:foodGroupId]];
            [foodNameEntity setFoodSourceId:[formatter numberFromString:foodSourceId]];
            [foodNameEntity setEnglishName:longNameEnglish];
            [foodNameEntity setFrenchName:longNameFrench];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
            
            //NSLog(@"%@\n", foodId);
            if([foodId compare:@"4"] == NSOrderedSame) return;

            
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
            NSString *nutritiveId = [content objectAtIndex:1];
            NSString *nutrientValue = [content objectAtIndex:2];
            NSString *nutritiveSourceId = [content objectAtIndex:5];
            
            NutritiveValue *nutritiveValueEntity = (NutritiveValue *)[NSEntityDescription insertNewObjectForEntityForName:@"NutritiveValue" inManagedObjectContext:managedObjectContext];
            [nutritiveValueEntity setFoodId:[formatter numberFromString:foodId]];
            [nutritiveValueEntity setNutritiveId:[formatter numberFromString:nutritiveId]];
            [nutritiveValueEntity setNutritiveValue:[formatter numberFromString:nutrientValue]];
            [nutritiveValueEntity setNutritiveSourceId:[formatter numberFromString:nutritiveSourceId]];
            
            FoodName *foodName = [finder getFoodName:[formatter numberFromString:foodId]];
            if(foodName != nil) {
                [nutritiveValueEntity setFoodName:foodName];
                //[foodName addNutritiveValuesObject:nutritiveValueEntity];
            } else {
                NSLog(@"FoodName not found with id %@ for entity NutritiveValue", foodId);
            }
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
            
            //NSLog(@"%@\n", nutrientValueLine);
            if([foodId compare:@"4"] == NSOrderedSame) return;
        }
        else {
            NSLog(@"NutritiveValueLine does not have 7 elements");
        }
    }
}

- (void) processConversionFactor:(NSArray *) list{
    
}

- (void) processFoodSource:(NSArray *) list {
    
}

- (void) processGroupName:(NSArray *) list {
    
}

- (void) processMesure:(NSArray *) list {
    
}

- (void) processNutritiveName:(NSArray *) list {
    
}

- (void) processNutritiveSource:(NSArray *) list {
    
}

- (void) processRefuse:(NSArray *) list {
    
}

- (void) processRefuseName:(NSArray *) list {

}

- (void) processYield:(NSArray *) list {
    
}

- (void) processYieldName:(NSArray *) list {
    
}

@end

