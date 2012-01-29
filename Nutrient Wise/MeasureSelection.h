//
//  MeasureSelection.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"
#import "ConversionFactor.h"

@protocol MeasureSelectionDelegate <NSObject>
- (void) conversionFactorSelected:(ConversionFactor *) conversionFactor;
@end

@interface MeasureSelection : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *conversionFactors;
@property (strong, nonatomic) ConversionFactor *selectedConversionFactor;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (nonatomic, assign) id  <MeasureSelectionDelegate> delegate;  

- (id) initWithConversionFactors:(NSArray *) pConversionFactors:(ConversionFactor *)pSelectedConversionFactor;

@end
