//
//  Refuse.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Refuse : NSManagedObject

@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSNumber * refuseNameId;
@property (nonatomic, retain) NSDecimalNumber * refuseAmount;
@property (nonatomic, retain) NSManagedObject *refuseName;

@end
