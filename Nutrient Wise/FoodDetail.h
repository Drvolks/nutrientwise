//
//  FoodDetail.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodName.h"

@interface FoodDetail : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) FoodName *food;
@property (strong, nonatomic) NSArray *nutritiveValues;

- (id)initWithFood:(FoodName *)foodEntity;
- (NSArray *) nutritiveValueKeys;
- (NSArray *) nutritiveValues:(NSArray *)keys;
- (BOOL) isFrench;

@end
