//
//  NutrientValueCell.h
//  Nutrient Wise
//
//  Created by Jean-Francois on 2013-08-13.
//
//

#import <UIKit/UIKit.h>

@interface NutrientValueCell : UITableViewCell

@property (nonatomic) BOOL avecIndex;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          avecIndex:(BOOL)pAvecIndex;

@end
