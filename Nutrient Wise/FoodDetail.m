//
//  FoodDetail.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodDetail.h"
#import "NutritiveValue.h"
#import "NutritiveName.h"

#define kTitle @"NutritiveValues"
#define kNutritiveNameColumn @"nutritiveName"
#define kNutritiveNameCodeColumn @"nutritiveNameCode"
#define kNutritiveValuesAttribute @"nutritiveValues"
#define kNutritiveValueColumn @"nutritiveValue"
#define kRowIdentifier @"rowIdentifier"

@implementation FoodDetail

@synthesize foodName;
@synthesize food;
@synthesize nutritiveValues;
@synthesize table;
@synthesize language;

- (id)initWithFood:(FoodName *)foodEntity {
    self.food = foodEntity;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.language = [[Language alloc] init];
    
    self.title = [language localizedString:kTitle];
    
    NSArray *keys = [self nutritiveValueKeys];
    self.nutritiveValues = [self nutritiveValues:keys];
}

- (void) prepareDisplay {
    [self initializeFoodNameLabel];
}

- (void) initializeFoodNameLabel {
    foodName.text = [food valueForKey:[language nameColumn]];
    foodName.font = [UIFont systemFontOfSize:12];
    foodName.numberOfLines = 2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSArray *) nutritiveValueKeys {
    NSArray *keys = [[NSArray alloc] initWithObjects:@"KCAL", nil];
    return keys;
}

- (NSArray *) nutritiveValues:(NSArray *)keys {
    NSSet *nutritiveValueEntities = [food valueForKey:kNutritiveValuesAttribute];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for(NutritiveValue *nutritiveValue in nutritiveValueEntities) {
        NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];
        NSString *name = [nutritiveName valueForKey:kNutritiveNameCodeColumn];
        
        for(NSString *nutritiveNameCode in keys) {
            if([nutritiveNameCode compare:name] == NSOrderedSame) {
                [result addObject:nutritiveValue];
            }
        }
    }
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nutritiveValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NutritiveValue *nutritiveValue = [self.nutritiveValues objectAtIndex:row];
    NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];
    
    NSString *name = [nutritiveName valueForKey:[language nameColumn]];
    
    NSDecimalNumber *value = [nutritiveValue valueForKey:kNutritiveValueColumn];
    
    NSString *text = [name stringByAppendingFormat:@"=%@", value];
    cell.textLabel.text = text;
    
    return cell; 
}


@end
