//
//  Finder.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodName.h"

@interface Finder : NSObject {
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id)initWithContext:(NSManagedObjectContext *)mObjectContext;
- (FoodName *) getFoodName:(NSNumber *) foodId;

@end
