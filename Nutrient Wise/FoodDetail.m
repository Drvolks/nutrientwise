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
#import "MeasureSelection.h"
#import "AllNutritiveValues.h"
#import "ArrayHelper.h"

#define kDebug NO
#define kTitle @"NutritiveValues"
#define kNutritiveSymbolColumn @"nutritiveSymbol"
#define kNutritiveValuesAttribute @"nutritiveValues"
#define kRowIdentifierMeasure @"rowIdentifierMeasure"
#define kRowIdentifierNutient @"rowIdentifierNutient"
#define kRowIdentifierAll @"rowIdentifierAll"
#define kFoodIdColumn @"foodId"
#define kConversionFactorsAttribute @"conversionFactors"
#define kMeasureColumn @"maesure"
#define kMeasureIdColumn @"measureId"
#define kNutritiveNameColumn @"nutritiveName"
#define kMeasureShouldStartWith @"1 "
#define kSortPrefix @"nutritiveName."
#define kSelectedMeasureSectionTitle @"Selected Measure"
#define kGeneralInformationSectionTitle @"General Information"
#define kProfileSectionTitle @"Values for profile "
#define kAllNutritiveValueCellTitle @"All Nutritive Values"
#define kDefaultNoMeasure @"100g"
#define kBackButtonSuffix @"..."
#define kMeasureSection 0
#define kFirstNutritiveValuesSection 1
#define kNumberOfSectionGeneric 4
#define kNumberOfSectionNonGeneric 3

@implementation FoodDetail

@synthesize foodName;
@synthesize nutritiveValues;
@synthesize table;
@synthesize languageHelper;
@synthesize arrayHelper;
@synthesize profileHelper;
@synthesize favoriteHelper;
@synthesize selectedConversionFactor;
@synthesize cellHelper;
@synthesize genericValues;
@synthesize activity;

- (id)initWithFood:(FoodName *)foodEntity {
    self = [super initWithNibName:@"FoodDetail" bundle:nil];
    if (self) {
        foodName = foodEntity;
    }
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

    self.view.backgroundColor = [UIColor systemBackgroundColor];
    table.backgroundColor = [UIColor systemBackgroundColor];

    languageHelper = [LanguageHelper sharedInstance];
    profileHelper = [ProfileHelper sharedInstance];
    favoriteHelper = [FavoriteHelper sharedInstance];
    cellHelper = [CellHelper sharedInstance];
    arrayHelper = [ArrayHelper sharedInstance];
    
    self.title = [languageHelper localizedString:kTitle];
    
    NSArray *keys = [self nutritiveValueKeys:[profileHelper selectedProfile]];
    nutritiveValues = [self nutritiveValues:keys];

    //Sort Data
    NSString *pkey = [kSortPrefix stringByAppendingString:[languageHelper nameColumn]];
    nutritiveValues = [arrayHelper sort:nutritiveValues key:pkey ascending:YES];
    
    if(![profileHelper genericProfileSelected]) {
        keys = [self nutritiveValueKeys:[profileHelper genericProfileKey]];
        keys = [self cleanGenericValues:keys];
        genericValues = [self nutritiveValues:keys];
        
        pkey = [kSortPrefix stringByAppendingString:[languageHelper nameColumn]];
        genericValues = [arrayHelper sort:genericValues key:pkey ascending:YES];
    } else {
        genericValues = nil;
    }
    
    [self prepareDisplay];
}


- (NSArray *) cleanGenericValues:(NSArray *) allKeys {
    NSArray *profileKeys = [self nutritiveValueKeys:[profileHelper selectedProfile]];
    NSMutableArray *newValues = [[NSMutableArray alloc] init];

    for(NSString *key in allKeys) {
        BOOL found = NO;
        for(NSString *profileKey in profileKeys) {
            if([profileKey isEqualToString:key]) {
                found = YES;
                break;
            }
        }
        
        if(!found) {
            [newValues addObject:key];
        }
    }
    
    return newValues;
}

- (void) prepareDisplay {
    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    navigationLabel.text = [foodName valueForKey:[languageHelper nameColumn]];
    navigationLabel.font = [UIFont systemFontOfSize:12];
    navigationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    navigationLabel.numberOfLines = 2;
    self.navigationItem.titleView = navigationLabel;
    
    [self initFavotiteButton];
    
    if(selectedConversionFactor == nil) {
        NSNumber *favoriteConversion = [favoriteHelper favoriteConversionMeasure:foodName];
        NSSet *conversionFactors = [foodName valueForKey:kConversionFactorsAttribute];
        if(favoriteConversion != nil) {
            for(ConversionFactor *conversionFactor in conversionFactors) {
                Measure *measure = [conversionFactor valueForKey:kMeasureColumn];
                NSNumber *measureId = [measure valueForKey:kMeasureIdColumn];
                
                if([measureId isEqualToNumber:favoriteConversion]) {
                    selectedConversionFactor = conversionFactor;
                }
            }
        }

        if(selectedConversionFactor == nil && [conversionFactors count] > 0) {
            // pick any conversion
            selectedConversionFactor = [self pickAConversionFactor:conversionFactors];
        }
    }

    if(kDebug) {
        NSLog(@"Preparing display for FoodId %@", [foodName valueForKey:kFoodIdColumn]);
    }
}

- (void) initFavotiteButton {
    UIImage *buttonImage = [UIImage imageNamed:@"NotFavorite"];
    if([favoriteHelper isFavorite:foodName])
    {
        buttonImage = [UIImage imageNamed:@"Favorite"];
    }
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(favoritePressed:)];
    
    self.navigationItem.rightBarButtonItem = favoriteButton;
}

- (void)favoritePressed:(id)sender {
    if([favoriteHelper isFavorite:foodName])
    {
        [favoriteHelper removeFavorite:foodName];
    } else {
        [favoriteHelper addFoodToFavorite:foodName];
    }

    [self initFavotiteButton];
    
}

- (ConversionFactor *) pickAConversionFactor:(NSSet *)conversionFactors {
    for(ConversionFactor *conversionFactor in conversionFactors) {
        Measure *measure = [conversionFactor valueForKey:kMeasureColumn];
        NSString *name = [measure valueForKey:[languageHelper nameColumn]];
        
        if(name != nil && [name length] > 3) {
            NSString *begin = [name substringToIndex:2];
            if([begin isEqualToString:kMeasureShouldStartWith]) {
                return conversionFactor;
            }
        }
    }
               
    return [[conversionFactors allObjects] objectAtIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    foodName = nil;
    nutritiveValues = nil;
    languageHelper = nil;
    arrayHelper = nil;
    profileHelper = nil;
    favoriteHelper = nil;
    selectedConversionFactor = nil;
    cellHelper = nil;
    genericValues = nil;
    table = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSArray *) nutritiveValueKeys:(NSString *) profile {
    return [profileHelper nutritiveSymbolsForProfile:profile];
}

- (NSArray *) nutritiveValues:(NSArray *)keys {
    NSSet *nutritiveValueEntities = [foodName valueForKey:kNutritiveValuesAttribute];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    int allSection = 2;
    int genericSection = -1;
    if(genericValues != nil) {
        allSection = 3;
        genericSection = 2;
    }
    
    if (section == kMeasureSection) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierMeasure];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierMeasure];
        }
        
        if(selectedConversionFactor != nil) {
            Measure *measure = [selectedConversionFactor valueForKey:kMeasureColumn];
            cell.textLabel.text = [measure valueForKey:[languageHelper nameColumn]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.textLabel.text = [languageHelper localizedString:kDefaultNoMeasure];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if(section == kFirstNutritiveValuesSection) {
        return [cellHelper makeNutientValueCell:tableView rowIdentifier:kRowIdentifierNutient nutritiveValues:nutritiveValues indexPath:indexPath conversionFactor:selectedConversionFactor avecIndex:FALSE];
    } 
    else if(section == genericSection) {
        return [cellHelper makeNutientValueCell:tableView rowIdentifier:kRowIdentifierNutient nutritiveValues:genericValues indexPath:indexPath conversionFactor:selectedConversionFactor avecIndex:FALSE];
    }
    else if(section == allSection) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierAll];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierAll];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [languageHelper localizedString:kAllNutritiveValueCellTitle];
        
        return cell;
    }
    
    return nil; 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(genericValues == nil) {
        return kNumberOfSectionNonGeneric;
    } else {
        return kNumberOfSectionGeneric;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int allSection = 2;
    int genericSection = -1;
    if(genericValues != nil) {
        allSection = 3;
        genericSection = 2;
    }
    
    if(section == kMeasureSection) {
        return 1;
    } else if(section == kFirstNutritiveValuesSection) {
        return [self.nutritiveValues count];
    } else if (section == genericSection) {
        return [self.genericValues count];
    } else if (section == allSection) {
        return 1;
    }
    
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    int allSection = 2;
    int genericSection = -1;
    if(genericValues != nil) {
        allSection = 3;
        genericSection = 2;
    }
    
    if(section == kMeasureSection) {
         return [languageHelper localizedString:kSelectedMeasureSectionTitle];
    } else if(section == kFirstNutritiveValuesSection) {
        if(genericValues  == nil) {
            return [languageHelper localizedString:kGeneralInformationSectionTitle];
        }
        else {
            return [[languageHelper localizedString:kProfileSectionTitle] stringByAppendingString:[languageHelper localizedString:[profileHelper selectedProfile]]];
        }
    } else if (section == genericSection) {
        return [languageHelper localizedString:kGeneralInformationSectionTitle];
    } else if (section == allSection) {
        return nil;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    int allSection = 2;
    int genericSection = -1;
    if(genericValues != nil) {
        allSection = 3;
        genericSection = 2;
    }
    
    NSString *title = [foodName valueForKey:[languageHelper nameColumn]];
    if([title length] > 20) {
        title = [[title substringToIndex:20] stringByAppendingString:kBackButtonSuffix];
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    if(section == kMeasureSection && selectedConversionFactor != nil) {
        NSSet *conversionFactors = [foodName valueForKey:kConversionFactorsAttribute];
        MeasureSelection *measureSelectionView = [[MeasureSelection alloc] initWithConversionFactors :[conversionFactors allObjects]selectedConversionFactor:selectedConversionFactor];
        [measureSelectionView setDelegate:self];
        [self.navigationController pushViewController:measureSelectionView animated:YES];
    }
    else if(section == allSection) {
        AllNutritiveValues *allView = [[AllNutritiveValues alloc] initWithFoodName:foodName conversionFactor:selectedConversionFactor];
        [self.navigationController pushViewController:allView animated:YES];
        allView = nil;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) conversionFactorSelected:(ConversionFactor *) conversionFactor {
    selectedConversionFactor = conversionFactor;
    
    [favoriteHelper addConversionToFavorite:conversionFactor foodName:foodName];
    
    [table reloadData];
}

@end
