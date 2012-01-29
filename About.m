//
//  About.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "About.h"

#define kTitle @"About"

@implementation About

@synthesize about;
@synthesize languageHelper;

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
    
    self.title = [languageHelper localizedString:kTitle];
    
    NSString *text = [languageHelper localizedString:@"About Us"];
    text = [text stringByAppendingString:@"\n\n"];
    text = [text stringByAppendingString:[languageHelper localizedString:@"About Data"]];
    text = [text stringByAppendingString:@"\n\n"];
    text = [text stringByAppendingString:[languageHelper localizedString:@"About Tab Icons"]];
    about.text = text;
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

@end
