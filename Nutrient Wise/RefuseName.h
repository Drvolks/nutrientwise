//
//  RefuseName.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RefuseName : NSManagedObject

@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSString * frenchName;
@property (nonatomic, retain) NSNumber * refuseNameId;

@end