//
//  SettingsLanguage.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsLanguage.h"

#define kRowIdentifier @"LanguageCell"

@implementation SettingsLanguage

@synthesize languages;
@synthesize languageHelper;
@synthesize delegate;
@synthesize selectedLanguage;
@synthesize finder;

- (id)initWithLanguage:(NSString *) pSelectedLanguage {
    selectedLanguage =pSelectedLanguage;
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
    
    languages = [languageHelper supportedLanguages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    languages = nil;
    languageHelper = nil;
    delegate = nil;
    selectedLanguage = nil;
    finder = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [languages count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSString *language = [languages objectAtIndex:row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[self delegate] languageSelected:language];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifier];
    }
    
    NSString *currentLanguage = [languages objectAtIndex:row];
    
    if([selectedLanguage isEqualToString:currentLanguage]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    cell.textLabel.text = [languageHelper localizedString:currentLanguage];
        
    return cell;
}

@end
