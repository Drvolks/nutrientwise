#import "Importer.h"
#import "FoodName.h"

@implementation Importer

@synthesize managedObjectContext;

- (void)importData:(NSManagedObjectContext *)mObjectContext
{
    self.managedObjectContext = mObjectContext;
    
    NSArray *foodNameLines = [self loadFile:@"FOOD_NM"];
    
    [self processFoodName:foodNameLines];
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
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    
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
            [foodNameEntity setFoodGroupId:[formatter numberFromString:foodGroupId]];
            [foodNameEntity setFoodSourceId:[formatter numberFromString:foodSourceId]];
            [foodNameEntity setLongNameEnglish:longNameEnglish];
            [foodNameEntity setLongNameFrench:longNameFrench];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
            
        }
    }
}

@end

