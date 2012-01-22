//
//  FoodDetail.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodName.h"
#import "Language.h"

@interface FoodDetail : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) FoodName *food;
@property (strong, nonatomic) NSArray *nutritiveValues;
@property (strong, nonatomic) Language *language;

- (id)initWithFood:(FoodName *)foodEntity;
- (NSArray *) nutritiveValueKeys;
- (NSArray *) nutritiveValues:(NSArray *)keys;
- (void) prepareDisplay;
- (void) initializeFoodNameLabel;

@end
