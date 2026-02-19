//
//  Settings.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "SettingsLanguage.h"
#import "About.h"
#import "AppDelegate.h"

#define kRowIdentifierLanguage @"LanguageCell"
#define kRowIdentifierAbout @"AboutCell"
#define kTitle @"Settings"
#define kAboutTitle @"About"
#define kLanguageTitle @"Language"
#define kLanguageSection 0
#define kAboutSection 1
#define kNumberOfSection 2

@implementation Settings

@synthesize languageHelper;
@synthesize finder;
@synthesize table;

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

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate registerLanguageDelegate:self];
    
    [self languageChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    languageHelper = nil;
    finder = nil;
    table = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kLanguageSection:
            return 1;
            break;
        case kAboutSection:
            return 1;
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kLanguageSection:
            return [languageHelper localizedString:kLanguageTitle];
            break;
        case (1):
            return nil;
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];

    if(section == kLanguageSection) {
        SettingsLanguage *languageView = [[SettingsLanguage alloc] initWithLanguage:[languageHelper language]];
        [languageView setDelegate:self];
        [self.navigationController pushViewController:languageView animated:YES];
    } else if(section == kAboutSection) {
        About *about = [[About alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if (section == kLanguageSection) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierLanguage];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierLanguage];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [languageHelper localizedString:[languageHelper language]];
        
        return cell;
    }
    else if (section == kAboutSection) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierAbout];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierAbout];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [languageHelper localizedString:kAboutTitle];
        
        return cell;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    return nil; 
}

- (void) languageSelected:(NSString *) language {
    [languageHelper setLanguage:language];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate fireLanguageChanged];
    
    [table reloadData];
}

- (void) languageChanged {
    self.navigationItem.title = [languageHelper localizedString:kTitle];
    self.title = [languageHelper localizedString:kTitle];
}

@end
