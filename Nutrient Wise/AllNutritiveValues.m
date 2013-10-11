//
//  AllNutritiveValues.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllNutritiveValues.h"
#import "NutritiveName.h"
#import "NutritiveValue.h"
#import "ArrayHelper.h"

#define kNutritiveValuesAttribute @"nutritiveValues"
#define kRowIdentifier @"rowIdentifier"
#define kUnitColumn @"unit"
#define kConversionFactorColumn @"conversionFactor"
#define kNutritiveValueColumn @"nutritiveValue"
#define kNutritiveNameColumn @"nutritiveName"
#define kSortAttribute @"nutritiveName."

@implementation AllNutritiveValues

@synthesize foodName;
@synthesize nutritiveValues;
@synthesize selectedConversionFactor;
@synthesize languageHelper;
@synthesize arrayHelper;
@synthesize cellHelper;
@synthesize keys;
@synthesize nutritiveValuesIndex;

- (id) initWithFoodName:(FoodName *)food
                       conversionFactor:(ConversionFactor *) conversionFactor {
    foodName = food;
    selectedConversionFactor = conversionFactor;
    NSSet *nutritiveValueEntities = [foodName valueForKey:kNutritiveValuesAttribute];    
    nutritiveValues = [nutritiveValueEntities allObjects];
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
    
    languageHelper = [LanguageHelper sharedInstance];
    arrayHelper = [ArrayHelper sharedInstance];

    cellHelper = [CellHelper sharedInstance];
    
    //Sort Data
    NSString *pkey = [kSortAttribute stringByAppendingString:[languageHelper nameColumn]];
    nutritiveValues = [arrayHelper sort:nutritiveValues key:pkey ascending:YES];
    
    [self buildIndex];
}

- (void) buildIndex {
    nutritiveValuesIndex = [[NSMutableDictionary alloc] init];
    keys = [[NSMutableArray alloc] init];
    
    for(NutritiveValue *nutritiveValue in nutritiveValues) {
        NutritiveName *nutrientName = [nutritiveValue valueForKey:kNutritiveNameColumn];
        NSString *name = [nutrientName valueForKey:[languageHelper nameColumn]];
        NSString *nameDecomposed = [self decomposeAndFilterString:name];
        NSString *firstLetter = [[nameDecomposed substringToIndex:1] uppercaseString];
        
        NSMutableArray *valuesInLetter = [nutritiveValuesIndex objectForKey:firstLetter];
        if(valuesInLetter == nil) {
            valuesInLetter = [[NSMutableArray alloc] init];
            [keys addObject:firstLetter];
        }
        
        [valuesInLetter addObject:nutritiveValue];
        [nutritiveValuesIndex setObject:valuesInLetter forKey:firstLetter];
    }
}

- (NSString*) decomposeAndFilterString: (NSString*) string
{
    NSMutableString *decomposedString = [[string decomposedStringWithCanonicalMapping] mutableCopy];
    NSCharacterSet *nonBaseSet = [NSCharacterSet nonBaseCharacterSet];
    NSRange range = NSMakeRange([decomposedString length], 0);
    
    while (range.location > 0) {
        range = [decomposedString rangeOfCharacterFromSet:nonBaseSet
                                                  options:NSBackwardsSearch range:NSMakeRange(0, range.location)];
        if (range.length == 0) {
            break;
        }
        [decomposedString deleteCharactersInRange:range];
    }
    
    return decomposedString;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    foodName = nil;
    nutritiveValues = nil;
    selectedConversionFactor = nil;
    languageHelper = nil;
    arrayHelper = nil;
    cellHelper = nil;
    keys = nil;
    nutritiveValuesIndex = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([keys count] == 0) {
        return 0;
    }
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nutientInSection = [nutritiveValuesIndex objectForKey:key];
    
    return [nutientInSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {      
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nutientInSection = [nutritiveValuesIndex objectForKey:key];
    
    return [cellHelper makeNutientValueCell:tableView rowIdentifier:kRowIdentifier nutritiveValues:nutientInSection indexPath:indexPath conversionFactor:selectedConversionFactor avecIndex:TRUE];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([keys count] > 0) ? [keys count] : 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return keys;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([keys count] > 0) {
        return [keys objectAtIndex:section];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
