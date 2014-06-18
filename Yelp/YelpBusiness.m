//
//  YelpBusiness.m
//  Yelp
//
//  Created by Patil, Sagar on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpBusiness.h"

@implementation YelpBusiness

- (NSString *) getCategoriesString{
    NSString *categoryString = @"";
    
    for (int i = 0; i < self.categories.count; i++) {
        if (i == 0) {
            categoryString = self.categories[i][0];
        }
        else {
            categoryString = [categoryString stringByAppendingFormat:@", %@", self.categories[i][0]];
        }
    }
    
    return categoryString;
}
- (id)initWithBusinessData:(NSDictionary *)businessData{
    
    self = [super init];
    
    self.name = [businessData objectForKey:@"name"];
    self.reviewCount = [[businessData objectForKey:@"review_count"] integerValue];
    self.ratingImageURL = [businessData objectForKey:@"rating_img_url_large"];
  
    NSDictionary *location = [businessData objectForKey:@"location"];
    self.address = [[location objectForKey:@"address"] componentsJoinedByString:@", "];
    if ([location objectForKey:@"neighborhoods"] ){
        self.address = [self.address stringByAppendingString:@", "];
        self.address = [self.address stringByAppendingString:[[location objectForKey:@"neighborhoods"] componentsJoinedByString:@", "]];
    }
    
    self.categories = [businessData objectForKey:@"categories"];
    self.imageURL = [businessData objectForKey:@"image_url"];
    
    
    return self;
}
@end
