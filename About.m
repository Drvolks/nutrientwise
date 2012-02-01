//
//  About.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "About.h"
#import "AppDelegate.h"

#define kTitle @"About"
#define kAboutUs @"About Us"
#define kAboutMore @"About More"
#define kSpaces @"\n\n"

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
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    languageHelper = [LanguageHelper sharedInstance];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate registerLanguageDelegate:self];
    
    [self languageChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    languageHelper = nil;
    about = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) languageChanged {
    self.title = [languageHelper localizedString:kTitle];
    
    NSString *text = [languageHelper localizedString:kAboutUs];
    text = [text stringByAppendingString:kSpaces];
    text = [text stringByAppendingString:[languageHelper localizedString:kAboutMore]];
    about.text = text;
}

@end
