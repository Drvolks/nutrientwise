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
    // Do any additional setup after loading the view from its nib.
    
    languageHelper = [LanguageHelper sharedInstance];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate registerLanguageDelegate:self];
    
    [self languageChanged];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return 1;
            break;
        case (1):
            return 1;
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return [languageHelper localizedString:@"Language"];
            break;
        case (1):
            return nil;
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if(section == 0) {
        SettingsLanguage *languageView = [[SettingsLanguage alloc] initWithLanguage:[languageHelper language]];
        [languageView setDelegate:self];
        [self.navigationController pushViewController:languageView animated:YES];
    } else if(section == 1) {
        About *about = [[About alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierLanguage];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierLanguage];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [languageHelper localizedString:[languageHelper language]];
        
        return cell;
    }
    else if (section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierAbout];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierAbout];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [languageHelper localizedString:@"About"];
        
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
    self.tabBarItem.title = [languageHelper localizedString:kTitle];
}

@end
