//
//  Importer.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Nutrient_Wise_Importer_h
#define Nutrient_Wise_Importer_h



#endif

@interface Importer : NSObject {
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    
- (void)importData:(NSManagedObjectContext *)mObjectContext;


- (NSArray *) loadFile:(NSString *) fileName;
- (void) processFoodName:(NSArray *) list;

@end