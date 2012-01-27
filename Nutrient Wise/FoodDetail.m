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
#import "Measure.h"
#import "NutientValueCell.h"
#import "MeasureSelection.h"
#import "AllNutritiveValues.h"

#define kDebug YES
#define kTitle @"NutritiveValues"
#define kNutritiveNameColumn @"nutritiveName"
#define kNutritiveSymbolColumn @"nutritiveSymbol"
#define kNutritiveValuesAttribute @"nutritiveValues"
#define kNutritiveValueColumn @"nutritiveValue"
#define kRowIdentifierMeasure @"rowIdentifierMeasure"
#define kRowIdentifierNutient @"rowIdentifierNutient"
#define kRowIdentifierAll @"rowIdentifierAll"
#define kFoodIdColumn @"foodId"
#define kConversionFactorsAttribute @"conversionFactors"
#define kMeasureColumn @"maesure"
#define kMeasureIdColumn @"measureId"
#define kUnitColumn @"unit"
#define kConversionFactorColumn @"conversionFactor"

@implementation FoodDetail

@synthesize foodName;
@synthesize food;
@synthesize nutritiveValues;
@synthesize table;
@synthesize languageHelper;
@synthesize profileHelper;
@synthesize favoriteHelper;
@synthesize favoriteButton;
@synthesize selectedConversionFactor;
@synthesize cellNibLoaded;

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
 
    self.languageHelper = [[LanguageHelper alloc] init];
    self.profileHelper = [[ProfileHelper alloc] init];
    self.favoriteHelper = [[FavoriteHelper alloc] init];
    
    self.title = [languageHelper localizedString:kTitle];
    
    NSArray *keys = [self nutritiveValueKeys];
    self.nutritiveValues = [self nutritiveValues:keys];
    
    cellNibLoaded = NO;
    
    [self prepareDisplay];
}

- (void) prepareDisplay {
    foodName.text = [food valueForKey:[languageHelper nameColumn]];
    foodName.font = [UIFont systemFontOfSize:12];
    foodName.numberOfLines = 2;
    
    BOOL isFavorite = [favoriteHelper isFavorite:food];
    if(isFavorite) {
        [favoriteButton setHidden:YES];
    } else {
        [favoriteButton setHidden:NO];
    }
    
    if(selectedConversionFactor == nil) {
        NSSet *conversionFactors = [food valueForKey:kConversionFactorsAttribute];
        selectedConversionFactor = [[conversionFactors allObjects] objectAtIndex:0];
    }

    if(kDebug) {
        NSLog(@"Preparing display for FoodId %@", [food valueForKey:kFoodIdColumn]);
    }
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
    return [profileHelper nutritiveSymbolsForProfile:@"TODO"];
}

- (NSArray *) nutritiveValues:(NSArray *)keys {
    NSSet *nutritiveValueEntities = [food valueForKey:kNutritiveValuesAttribute];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for(NutritiveValue *nutritiveValue in nutritiveValueEntities) {
        NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];
        NSString *symbol = [nutritiveName valueForKey:kNutritiveSymbolColumn];
        
        for(NSString *keySymbol in keys) {
            if([keySymbol isEqualToString:symbol]) {
                [result addObject:nutritiveValue];
            }
        }
    }
    
    return result;
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nutritiveValues count];
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierMeasure];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierMeasure];
        }
        
        Measure *measure = [selectedConversionFactor valueForKey:kMeasureColumn];
        cell.textLabel.text = [measure valueForKey:[languageHelper nameColumn]];
        
        return cell;
    }
    else if(section == 1) {
        if(!cellNibLoaded) {
            UINib *nib = [UINib nibWithNibName:@"NutientValueCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:kRowIdentifierNutient];
            cellNibLoaded = YES;
        }
        NutientValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierNutient];
        
        NutritiveValue *nutritiveValue = [self.nutritiveValues objectAtIndex:row];
        NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];

        cell.nutient.text = [nutritiveName valueForKey:[languageHelper nameColumn]];
        
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 

        NSDecimalNumber *value = [nutritiveValue valueForKey:kNutritiveValueColumn];
        NSDecimalNumber *conversion = [selectedConversionFactor valueForKey:kConversionFactorColumn];
        if(kDebug) {
            NSLog(@"Nutritive value is %@", value);
            NSLog(@"Conversion factor is %@", conversion);
        }
        if(conversion != nil) {
            value = [value decimalNumberByMultiplyingBy:conversion];
        }
        cell.value.text = [[value decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
        cell.measure.text = [nutritiveName valueForKey:kUnitColumn];
        
        return cell;
    } 
    else if(section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierAll];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierAll];
        }
        
        cell.textLabel.text = @"All Values";
        
        return cell;
    }
    
    return nil; 
}

- (IBAction)favoriteButtonPressed:(id)sender {
    [favoriteHelper addToFavorite:self.food];
    
    [self prepareDisplay];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return 1;
            break;
        case (1):
            return [self.nutritiveValues count];
            break;
        case (2):
            return 1;
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return @"Measure";
            break;
        case (1):
            return @"Values";
            break;
        case (3):
            // no label
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if(section == 0) {
        NSSet *conversionFactors = [food valueForKey:kConversionFactorsAttribute];
        MeasureSelection *measureSelectionView = [[MeasureSelection alloc] initWithConversionFactors:[conversionFactors allObjects]];
        [measureSelectionView setDelegate:self];
        [self.navigationController pushViewController:measureSelectionView animated:YES];
    }
    else if(section == 2) {
        AllNutritiveValues *allView = [[AllNutritiveValues alloc] initWithFoodName:food :selectedConversionFactor];
        [self.navigationController pushViewController:allView animated:YES];
        allView = nil;
    }
}

- (void) conversionFactorSelected:(ConversionFactor *) conversionFactor {
    selectedConversionFactor = conversionFactor;
    [table reloadData];
}

@end
