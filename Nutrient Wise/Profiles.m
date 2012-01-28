//
//  Profiles.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Profiles.h"

#define kTitle @"Profile"
#define kRowIdentifierProfile @"ProfileRow"

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
    
    languageHelper = [[LanguageHelper alloc] init];
    profileHelper = [[ProfileHelper alloc] init];
    
    self.navigationItem.title = [languageHelper localizedString:kTitle];
    
    [self displayProfileInformation];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return 1;
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return [languageHelper localizedString:@"My Profile"];
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if(section == 0) {
        ProfileSelection *profileView = [[ProfileSelection alloc] init];
        [profileView setDelegate:self];
        [self.navigationController pushViewController:profileView animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierProfile];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierProfile];
        }
        
        cell.textLabel.text = [languageHelper localizedString:[profileHelper selectedProfile]];
        
        return cell;
    }
    
    return nil; 
}

- (void) profileSelected:(NSString *) profile {
    [profileHelper setSelectedProfile:profile];
    
    [self displayProfileInformation];
    
    [table reloadData];
}

- (void) displayProfileInformation {
    NSString *profile = [profileHelper selectedProfile];
    NSString *profileDesc = [profile stringByAppendingString:@" Desc"];
    
    NSString *text = [languageHelper localizedString:profileDesc];
    
    CGSize labelSize = CGSizeMake(250, 50);
    CGSize theStringSize = [text sizeWithFont:profileInformation.font constrainedToSize:labelSize lineBreakMode:profileInformation.lineBreakMode];
    profileInformation.frame = CGRectMake(profileInformation.frame.origin.x, profileInformation.frame.origin.y, theStringSize.width, theStringSize.height);
    
    profileInformation.text = text;
}

@end
