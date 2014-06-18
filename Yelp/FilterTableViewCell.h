//
//  FilterTableViewCell.h
//  Yelp
//
//  Created by Patil, Sagar on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descrptionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@end
