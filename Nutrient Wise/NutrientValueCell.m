//
//  NutrientValueCell.m
//  Nutrient Wise
//
//  Created by Jean-Francois on 2013-08-13.
//
//

#import "NutrientValueCell.h"

@implementation NutrientValueCell

@synthesize avecIndex;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier avecIndex:FALSE];
}

- (id)initWithStyle:(UITableViewCellStyle)style
        reuseIdentifier:(NSString *)reuseIdentifier
          avecIndex:(BOOL)pAvecIndex
{
    avecIndex = pAvecIndex;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        //[self definirTailleLabels];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self definirTailleLabels];
}

- (void) definirTailleLabels {
    int pos = 245;
    if(avecIndex == YES) {
        pos = 235;
    }
    
    self.textLabel.frame = CGRectMake(15, 10, pos-20, 20);
    self.detailTextLabel.frame = CGRectMake(pos,10,65,20);
}

@end
