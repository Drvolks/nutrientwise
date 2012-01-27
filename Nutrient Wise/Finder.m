//
//  Finder.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Finder.h"

#define kDebug YES
#define kFoodNameEntity @"FoodName"

@implementation Finder

@synthesize managedObjectContext;
@synthesize languageHelper;

- (id)initWithContext:(NSManagedObjectContext *)mObjectContext {
    self.managedObjectContext = mObjectContext;

    self.languageHelper = [[LanguageHelper alloc] init];
    
    return self;
}

- (FoodName *) getFoodName:(NSNumber *) foodId
{
    NSLog(@"Find FoodName for id %@\n", foodId);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kFoodNameEntity inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(foodId = %@)", foodId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Number of result %d", [result count]);
    if(result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray *) searchFoodByName:(NSString *)text {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kFoodNameEntity inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[self predicateWithNameColumn:text]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return result;
}

- (NSArray *) searchFoodById:(NSArray *) foodIds {
    // TODO not working
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kFoodNameEntity inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(foodId in %@)", foodIds];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return result;
}

- (NSString *) predicateWithNameColumn:(NSString *) searchTerm {
    NSString *predicate = @"";
    BOOL *first = YES;
    
    NSArray *words = [searchTerm componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for(NSString *word in words) {
        if([word length] > 0) {
            if(!first) {
                predicate = [predicate stringByAppendingString:@" && "];
            } else {
                first = NO;
            }
            predicate = [predicate stringByAppendingString:[languageHelper nameColumn]];
            predicate = [predicate stringByAppendingFormat:@" contains[cd] '%@'", word];
        }
    }
        
    if(kDebug) {
        NSLog(@"Predicate is %@", predicate);
    }
    
    return predicate;
}

@end
