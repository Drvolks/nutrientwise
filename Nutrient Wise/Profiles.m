//
//  Profiles.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Profiles.h"
#import "AppDelegate.h"

#define kTitle @"Profile"
#define kRowIdentifierProfile @"ProfileRow"
#define kProfileSection 0
#define kNumberOfSections 1
#define kProfileKeySuffix @" Desc"
#define kFooter @"Profile Footer"
#define kMyProfile @"My Profile"
#define kSpacer @"\n\n"

@implementation Profiles

@synthesize finder;
@synthesize languageHelper;
@synthesize table;
@synthesize profileHelper;
@synthesize profileInformation;

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
    profileHelper = [ProfileHelper sharedInstance];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate registerLanguageDelegate:self];
    
    [self languageChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    finder = nil;
    languageHelper = nil;
    table = nil;
    profileHelper = nil;
    profileInformation = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kProfileSection:
            return 1;
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return [languageHelper localizedString:kMyProfile];
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if(section == kProfileSection) {
        ProfileSelection *profileView = [[ProfileSelection alloc] initWithProfile:[profileHelper selectedProfile]];
        [profileView setDelegate:self];
        [self.navigationController pushViewController:profileView animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if (section == kProfileSection) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierProfile];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierProfile];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *text = [languageHelper localizedString:[profileHelper selectedProfile]];
        cell.textLabel.text = text;
        
        return cell;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    return nil; 
}

- (void) profileSelected:(NSString *) profile {
    [profileHelper setSelectedProfile:profile];
    
    [self displayProfileInformation];
    
    [table reloadData];
}

- (void) displayProfileInformation {
    NSString *profile = [profileHelper selectedProfile];
    NSString *profileDesc = [profile stringByAppendingString:kProfileKeySuffix];
    
    NSString *text = [languageHelper localizedString:profileDesc];
    text = [text stringByAppendingString:kSpacer];
    text = [text stringByAppendingString:[languageHelper localizedString:kFooter]];
    
    profileInformation.text = text;
}

- (void) languageChanged {
    self.navigationItem.title = [languageHelper localizedString:kTitle];
    self.title = [languageHelper localizedString:kTitle];
    
    [self displayProfileInformation];
    
    [table reloadData];
}

@end
