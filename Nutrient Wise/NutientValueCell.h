//
//  NutientValueCell.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NutientValueCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nutient;
@property (strong, nonatomic) IBOutlet UILabel *value;
@property (strong, nonatomic) IBOutlet UILabel *measure;


@end
