//
//  MeasureSelection.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeasureSelection.h"
#import "ConversionFactor.h"
#import "Measure.h"
#import "FoodDetail.h"

#define kRowIdentifier @"rowIdentifier"
#define kMeasureColumn @"maesure"

@implementation MeasureSelection

@synthesize conversionFactors;
@synthesize languageHelper;
@synthesize delegate;

- (id) initWithConversionFactors:(NSArray *) pConversionFactors {
    self.conversionFactors = pConversionFactors;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    ConversionFactor *conversionFactor = [conversionFactors objectAtIndex:row];
    
    [[self delegate] conversionFactorSelected:conversionFactor];
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [conversionFactors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    ConversionFactor *conversionFactor = [conversionFactors objectAtIndex:row];
    Measure *measure = [conversionFactor valueForKey:kMeasureColumn];
    
    cell.textLabel.text = [measure valueForKey:[languageHelper nameColumn]];
    
    return cell; 
}

@end
