//
//  AllNutritiveValues.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllNutritiveValues.h"
#import "NutientValueCell.h"
#import "NutritiveName.h"
#import "NutritiveValue.h"

#define kNutritiveValuesAttribute @"nutritiveValues"
#define kRowIdentifier @"rowIdentifier"
#define kUnitColumn @"unit"
#define kConversionFactorColumn @"conversionFactor"
#define kNutritiveValueColumn @"nutritiveValue"
#define kNutritiveNameColumn @"nutritiveName"

@implementation AllNutritiveValues

@synthesize foodName;
@synthesize nutritiveValues;
@synthesize selectedConversionFactor;
@synthesize languageHelper;

- (id) initWithFoodName:(FoodName *)food:(ConversionFactor *) conversionFactor {
    foodName = food;
    selectedConversionFactor = conversionFactor;
    NSSet *nutritiveValueEntities = [foodName valueForKey:kNutritiveValuesAttribute];
    
    nutritiveValues = [nutritiveValueEntities sortedArrayUsingDescriptors:[nutritiveValueEntities valueForKey:kNutritiveNameColumn]];
    //nutritiveValues = [nutritiveValueEntities allObjects];
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
    
    languageHelper = [[LanguageHelper alloc] init];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [nutritiveValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
    static BOOL NutientCellNibLoaded = NO;
    
    NSUInteger row = [indexPath row];
    
    if(!NutientCellNibLoaded) {
        UINib *nib = [UINib nibWithNibName:@"NutientValueCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:kRowIdentifier];
        NutientCellNibLoaded = YES;
    }
    NutientValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifier];
    
    NutritiveValue *nutritiveValue = [self.nutritiveValues objectAtIndex:row];
    NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];
    
    cell.nutient.text = [nutritiveName valueForKey:[languageHelper nameColumn]];
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
    
    NSDecimalNumber *value = [nutritiveValue valueForKey:kNutritiveValueColumn];
    NSDecimalNumber *conversion = [selectedConversionFactor valueForKey:kConversionFactorColumn];
    value = [value decimalNumberByMultiplyingBy:conversion];
    cell.value.text = [[value decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
    cell.measure.text = [nutritiveName valueForKey:kUnitColumn];
    
    return cell;

}


@end
