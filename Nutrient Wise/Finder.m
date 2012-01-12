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

@end
