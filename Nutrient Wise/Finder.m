//
//  Finder.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Finder.h"

@implementation Finder

@synthesize managedObjectContext;

- (id)initWithContext:(NSManagedObjectContext *)mObjectContext {
    self.managedObjectContext = mObjectContext;

    return self;
}

- (FoodName *) getFoodName:(NSNumber *) foodId
{
    //NSLog(@"Find FoodName for id %@\n", foodId);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"FoodName" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(foodId = %@)", foodId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"Number of result %d", [result count]);
    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray *) searchFoodByName:(NSString *)text:(BOOL *) french {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"FoodName" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(englishName contains[cd] %@)", text];
    if(french) {
        predicate = [NSPredicate predicateWithFormat:@"(frenchName contains[cd] %@)", text];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return result;

}

- (Measure *) getMeasure:(NSNumber *) measureId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Measure" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(measureId = %@)", measureId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (RefuseName *) getRefuseName:(NSNumber *)refuseNameId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RefuseName" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(refuseNameId = %@)", refuseNameId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (YieldName *) getYieldName:(NSNumber *)yieldNameId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"YieldName" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(yieldNameId = %@)", yieldNameId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (FoodSource *) getFoodSource:(NSNumber *)foodSourceId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"FoodSource" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(foodSourceId = %@)", foodSourceId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (GroupName *) getGroupName:(NSNumber *)groupNameId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"GroupName" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(groupNameId = %@)", groupNameId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (NutritiveName *) getNutritiveName:(NSNumber *)nutritiveNameId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"NutritiveName" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(nutritiveNameId = %@)", nutritiveNameId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

@end
