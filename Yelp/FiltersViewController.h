//
//  FiltersViewController.h
//  Yelp
//
//  Created by Patil, Sagar on 6/16/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableViewCell.h"

@protocol FiltersViewControllerDelgate<NSObject>

@required

- (void)setDealsInSearch:(NSString *)onOff; //uses strings "on" and "off"
- (void)sortByInSearch:(NSString *)sortBy;
- (void)distanceInSearch:(NSString *)distance;
- (void)categoriesInSearch:(NSString *)categories;
@optional
- (void)searchButtonClicked;

@end
@interface FiltersViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<FiltersViewControllerDelgate> delegate;
@property (nonatomic,strong) NSMutableDictionary *optionsChosen;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
