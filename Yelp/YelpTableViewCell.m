//
//  YelpTableViewCell.m
//  Yelp
//
//  Created by Patil, Sagar on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpTableViewCell.h"
#import "UIImageView+AFNetworking.h"

static int NameLabelWidth=100.;

@implementation YelpTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initializeCell:(YelpBusiness *)business withIndex:(NSInteger)index{
    self.business=business;
    

    [self.businessNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.businessNameLabel setNumberOfLines:0];
    
    
    NSString *name = business.name;
    UIFont *font = [UIFont boldSystemFontOfSize: 17];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [name boundingRectWithSize:CGSizeMake(NameLabelWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];

    CGRect frame = self.businessNameLabel.frame;
    [self.businessNameLabel setFrame:CGRectMake(frame.origin.x, frame.origin.y, rect.size.width, rect.size.height)];
    [self.businessNameLabel setNumberOfLines:0];
    [self.businessNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
   // [self.businessNameLabel setBackgroundColor:[UIColor redColor]];
//    frame.size.height = size.height;
//    self.businessNameLabel.frame=frame;
    NSLog(@" Label height set to %f",self.businessNameLabel.frame.size.height);
    self.businessNameLabel.text = business.name;
//    [self.businessNameLabel sizeToFit];
    
    
    
    
    //self.distanceLabel.text = [NSString stringWithFormat: @"%.2fmi", business.distance];
//    self.priceLabel.text = [@"" stringByPaddingToLength:business.price withString:@"$" startingAtIndex:0];
    self.reviewsLabel.text = [NSString stringWithFormat:@"%i Reviews", business.reviewCount];
    self.addressLabel.text = business.address;
    
    self.categoryLabel.text = [business getCategoriesString];
    [self.businessImageView setImageWithURL:[NSURL URLWithString:business.imageURL]];
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:business.ratingImageURL]];
    
}

@end
