//
//  UISearchBar+UISearchBarLocalized.m
//  Nutrient Wise
//
//  Created by Jean-François on 2013-10-14.
//
// http://stackoverflow.com/questions/2536151/how-to-change-the-default-text-of-cancel-button-which-appears-in-the-uisearchbar/14509280#14509280
//
//

#import "UISearchBar+UISearchBarLocalized.h"

@implementation UISearchBar (UISearchBarLocalized)

- (void)cancelButton:(NSString*)text
{
    UIButton *cancelButton;
    UITextField *searchArea;
    UIView *topView = self.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            searchArea = (UITextField*)subView;
        }

    }
    if (cancelButton) {
        [cancelButton setTitle:text forState:UIControlStateNormal];
        cancelButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        cancelButton.frame = CGRectMake(230, 5, 100, 30);
    }
    if(searchArea) {
        searchArea.frame = CGRectMake(4, 5, 240, 30);
    }
}


@end
