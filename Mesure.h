//
//  Mesure.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mesure : NSManagedObject

@property (nonatomic, retain) NSNumber * mesureId;
@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSString * frenchName;

@end
