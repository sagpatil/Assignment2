//
//  FilterTableViewCell.m
//  Yelp
//
//  Created by Patil, Sagar on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

- (void)awakeFromNib
{
    [self.toggleSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"switch"];

     }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)switchClicked:(id)sender {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];

    if (self.toggleSwitch.on == YES) {
        [defaults setBool:YES forKey:@"switch"];

        NSLog(@"YES CLICK");
    }
    else{
         [defaults setBool:NO forKey:@"switch"];
    }

}


@end
