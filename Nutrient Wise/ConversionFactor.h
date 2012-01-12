//
//  ConversionFactor.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName, Mesure;

@interface ConversionFactor : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * conversionFactor;
@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSNumber * measureId;
@property (nonatomic, retain) FoodName *foodName;
@property (nonatomic, retain) Mesure *maesure;

@end
