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
#define kAboutHtmlFile @"about-"
#define kHtmlExt @"html"

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
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:[kAboutHtmlFile stringByAppendingString:[languageHelper language]] ofType:kHtmlExt inDirectory:nil];

    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [about loadHTMLString:htmlString baseURL:nil];
    
    //about.backgroundColor = [UIColor clearColor];
    //[about setOpaque:NO];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
