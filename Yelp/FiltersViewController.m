//
//  FiltersViewController.m
//  Yelp
//
//  Created by Patil, Sagar on 6/16/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"


@interface FiltersViewController ()


@property (nonatomic,strong) NSArray *extraCategoriesIndexPaths;
@property (nonatomic,strong) NSArray *sortByIndexPaths;
@property (nonatomic,strong) NSArray *distanceIndexPaths;
@property (nonatomic,strong) NSMutableDictionary *numberOfRowsWhenExpanded;
@property (nonatomic,strong) NSArray *dealsOptions;
@property (nonatomic,strong) NSArray *sortByOptions;
@property (nonatomic,strong) NSArray *distanceOptions;
@property (nonatomic,strong) NSArray *categoriesOptions;
@end

@implementation FiltersViewController

{
    BOOL expanded[4];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.optionsChosen= [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setTitle: @"Filters"];
    
    self.sortByIndexPaths = [NSArray arrayWithObjects:
                             [NSIndexPath indexPathForRow:1 inSection:1],
                             [NSIndexPath indexPathForRow:2 inSection:1],
                             nil];
    self.distanceIndexPaths = [NSArray arrayWithObjects:
                               [NSIndexPath indexPathForRow:1 inSection:2],
                               [NSIndexPath indexPathForRow:2 inSection:2],
                               [NSIndexPath indexPathForRow:3 inSection:2],
                               nil];
    // the fourth one is "see more"
    self.extraCategoriesIndexPaths = [NSArray arrayWithObjects:
                                      [NSIndexPath indexPathForRow:4 inSection:3],
                                      [NSIndexPath indexPathForRow:5 inSection:3],
                                      [NSIndexPath indexPathForRow:6 inSection:3],
                                      [NSIndexPath indexPathForRow:7 inSection:3],
                                      [NSIndexPath indexPathForRow:8 inSection:3],
                                      [NSIndexPath indexPathForRow:9 inSection:3],
                                      nil];
    
    //all the sections are not expanded when the view loads
    for(int i=0;i<4;i++) {
        expanded[i]=NO;
    }
    
    //set the number of rows
    self.numberOfRowsWhenExpanded=[[NSMutableDictionary alloc] init];
    //0: @"Deals", 1: @"SortBy", 2:@"Distance", 3:@"Categories"
    self.numberOfRowsWhenExpanded[@0]=[NSNumber numberWithInt:1];
    self.numberOfRowsWhenExpanded[@1]=[NSNumber numberWithInt:3];
    self.numberOfRowsWhenExpanded[@2]=[NSNumber numberWithInt:4];
    self.numberOfRowsWhenExpanded[@3]=[NSNumber numberWithInt:10];
    
    
    self.dealsOptions       = [NSArray arrayWithObjects:
                               @"on",@"off",nil];
    self.sortByOptions      = [NSArray arrayWithObjects:
                               @"Best Match",@"Distance",@"Highest Rated",nil];
    self.distanceOptions    = [NSArray arrayWithObjects:
                               @"100 meters",@"500 meters",@"1000 meters", @"2000 meters",nil];
    self.categoriesOptions  = [NSArray arrayWithObjects:
                               @"Indian",@"Italian",@"Bars",@"Pizza" ,@"Korean",@"Mexican",@"Japanese",
                               @"Thai", @"Seafood",@"Greek",nil];
    
    //set default options chosen
    if([self.optionsChosen[@"SortBy"] isEqual:@""]) {
        self.optionsChosen[@"SortBy"]=[NSString stringWithFormat:@"%@",self.sortByOptions[0]];
    }
    if([self.optionsChosen[@"Distance"] isEqual:@""]) {
        self.optionsChosen[@"Distance"]=[NSString stringWithFormat:@"%@",self.distanceOptions[0]];
    }
    if([self.optionsChosen[@"Categories"] isEqual:@""]) {
        self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[0]];
    }
    
    
    
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UINib *customCellNib= [UINib nibWithNibName:@"FilterTableViewCell" bundle:nil];
    [self.tableView registerNib:customCellNib forCellReuseIdentifier:@"FilterTableViewCell"];

}

#pragma mark - TableView meethods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber* numRows=self.numberOfRowsWhenExpanded[@(section)];
    if(expanded[section]) {
        return [numRows integerValue];
    }
    else {
        if(section==3)
            return 4;
        else
            return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor= [UIColor grayColor];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 320, 20)];
    switch(section) {
        case 0:
            label.text=@"Deals";
            break;
        case 1:
            label.text=@"Sort by";
            break;
        case 2:
            label.text=@"Radius";
            break;
        case 3:
            label.text=@"Categories";  //#bug todo set all the time
            if(![self.optionsChosen[@"Categories"] isEqualToString:@""]) {
                label.text=[label.text stringByAppendingFormat:@": %@", self.optionsChosen[@"Categories"]];
            }
            break;
    }
    [headerView addSubview:label];
    return headerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FilterTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //hide the switch by default
    cell.toggleSwitch.hidden = YES;
    cell.toggleSwitch.enabled = NO;
    
    NSLog(@" IndexPath  %ld - %ld", indexPath.section, indexPath.row);
    NSString *nameText = @"";
    if(expanded[indexPath.section])
    {
        switch(indexPath.section) {
            case 0:
                
                break;
            case 1:
                nameText=self.sortByOptions[indexPath.row];
                break;
            case 2:
                nameText=self.distanceOptions[indexPath.row];
                break;
            case 3:
                nameText=self.categoriesOptions[indexPath.row];
                break;
        }
    }
    else {
        switch(indexPath.section) {
            case 0:
                nameText = self.optionsChosen[@"Deals"];
                cell.toggleSwitch.hidden = NO;
                cell.toggleSwitch.enabled = YES;
                break;
            case 1:
                nameText=self.optionsChosen[@"SortBy"];
                break;
            case 2:
                nameText=self.optionsChosen[@"Distance"];
                break;
            case 3:
                //name=self.optionsChosen[@"Categories"];
                if(indexPath.row==3)
                {
                    nameText=@"See more..";
                }
                else {
                    nameText=self.categoriesOptions[indexPath.row];
                }
                break;
        }
    }
    
    cell.descrptionLabel.text = nameText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //toggle the table view first
    if(indexPath.section !=0)
        expanded[indexPath.section]=!expanded[indexPath.section];
  
    if(expanded[indexPath.section]) {
        switch (indexPath.section) {
            case 0:
                
                break;
            case 1:
                [self.tableView insertRowsAtIndexPaths:self.sortByIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
                break;
            case 2:
                [self.tableView insertRowsAtIndexPaths:self.distanceIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
                break;
            case 3:
                if (indexPath.row ==3 ) { // expand see more
                    [self.tableView insertRowsAtIndexPaths:self.extraCategoriesIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                }
                else
                {
                    self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[indexPath.row]];
                    [self.delegate categoriesInSearch:self.optionsChosen[@"Categories"]];
                }
                break;
            default:
                break;
        }
    }
    else{ // Collapse the expanded view and save the selection
        switch (indexPath.section) {
            case 0:
                break;
            case 1:
                 self.optionsChosen[@"SortBy"]=[NSString stringWithFormat:@"%@",self.sortByOptions[indexPath.row]]; // save selction
                [self.delegate sortByInSearch:self.optionsChosen[@"SortBy"]];
                [self.tableView deleteRowsAtIndexPaths:self.sortByIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 2:
                self.optionsChosen[@"Distance"]=[NSString stringWithFormat:@"%@",self.distanceOptions[indexPath.row]];
                [self.delegate distanceInSearch:self.optionsChosen[@"Distance"]];
                [self.tableView deleteRowsAtIndexPaths:self.distanceIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 3:
                self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[indexPath.row]];
                [self.delegate categoriesInSearch:self.optionsChosen[@"Categories"]];
                [self.tableView deleteRowsAtIndexPaths:self.extraCategoriesIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
    //reload that section
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

}



# pragma Private
- (IBAction)onCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSearchButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL dealSwitch=[defaults boolForKey:@"switch"];
    self.optionsChosen[@"Deals"]=dealSwitch ? @"on" : @"off" ;
    
    [self.delegate setDealsInSearch:self.optionsChosen[@"Deals"]];
    [self.delegate searchButtonClicked];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
