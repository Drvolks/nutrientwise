//
//  FoodSource.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FoodSource : NSManagedObject

@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSNumber * foodSourceCode;
@property (nonatomic, retain) NSNumber * foodSourceId;
@property (nonatomic, retain) NSString * frenchName;

@end
