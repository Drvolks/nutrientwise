//
//  ConversionFactor.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName;

@interface ConversionFactor : NSManagedObject

@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSNumber * mesureId;
@property (nonatomic, retain) NSDecimalNumber * conversionFactor;
@property (nonatomic, retain) FoodName *foodName;
@property (nonatomic, retain) NSManagedObject *mesure;

@end
