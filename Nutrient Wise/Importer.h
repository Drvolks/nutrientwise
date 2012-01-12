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

#import "Finder.h"

@interface Importer : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSNumberFormatter *formatter;
    Finder *finder;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSNumberFormatter *formatter;
@property (nonatomic, retain) Finder *finder;
    
- (void)importData;
- (id)initWithContext:(NSManagedObjectContext *)mObjectContext;

- (NSArray *) loadFile:(NSString *) fileName;
- (void) processFoodName:(NSArray *) list;
- (void) processNutritiveValue:(NSArray *) list;
- (void) processConversionFactor:(NSArray *) list;
- (void) processFoodSource:(NSArray *) list;
- (void) processGroupName:(NSArray *) list;
- (void) processMesure:(NSArray *) list;
- (void) processNutritiveName:(NSArray *) list;
- (void) processNutritiveSource:(NSArray *) list;
- (void) processRefuse:(NSArray *) list;
- (void) processRefuseName:(NSArray *) list;
- (void) processYield:(NSArray *) list;
- (void) processYieldName:(NSArray *) list;

@end