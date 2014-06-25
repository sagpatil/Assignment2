//
//  ResultViewController.m
//  Yelp
//
//  Created by Patil, Sagar on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ResultViewController.h"
#import "YelpTableViewCell.h"
#import "YelpClient.h"
#import "MBProgressHUD.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";



@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (nonatomic,strong) UISearchDisplayController *searchController;

@property (nonatomic, strong) YelpClient *client;

@property (nonatomic, strong) NSMutableArray *businesses;
@property (nonatomic, strong) NSDictionary *nameAttributes;
@property (nonatomic, strong) NSDictionary *otherAttributes;
@property (nonatomic,strong) FiltersViewController *filtersView;
@property (strong, nonatomic) NSString *searchKey;

@property (nonatomic,strong) NSMutableDictionary *optionsChosen;
//@property (nonatomic,assign) BOOL searchWithFilters;
@property (nonatomic,strong) NSMutableDictionary *categoriesYelpKeys;
@property (nonatomic,strong) NSMutableDictionary *sortByYelpKeys;

@property (nonatomic,strong)  YelpTableViewCell *stubCell;

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40.0, 0.0, 280.0, 44.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.barTintColor = [UIColor colorWithRed:255/255.0f green:0 blue:0 alpha:1.0f];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    
    UIButton *filterButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [filterButton addTarget:self action:@selector(onFilterButton:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    self.searchBar.delegate = self;
    [searchBarView addSubview:filterButton];
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;

    
    
    self.businesses = [[NSMutableArray alloc]init];
    self.searchKey =@"Thai";
    self.searchBar.text = self.searchKey;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    //set the filters view controller
    self.filtersView=[[FiltersViewController alloc] init];
    self.filtersView.delegate=self;
    
    self.optionsChosen= [[NSMutableDictionary alloc] init];
    self.optionsChosen[@"Deals"]=@"Offering Deal";
    self.optionsChosen[@"SortBy"]=@"";
    self.optionsChosen[@"Distance"]=@"";
    self.optionsChosen[@"Categories"]=@"";
    
    self.categoriesYelpKeys=[[NSMutableDictionary alloc] init];
    self.categoriesYelpKeys[@"Indian"]=@"indpak";
    self.categoriesYelpKeys[@"Italian"]=@"italian";
    self.categoriesYelpKeys[@"Japanese"]=@"japanese";
    self.categoriesYelpKeys[@"Korean"]=@"korean";
    self.categoriesYelpKeys[@"Pizza"]=@"pizza";
    self.categoriesYelpKeys[@"Thai"]=@"thai";
    self.categoriesYelpKeys[@"Seafood"]=@"seafood";
    self.categoriesYelpKeys[@"Bars"]=@"bars";
    self.categoriesYelpKeys[@"Greek"]=@"greek";
    self.categoriesYelpKeys[@"Mexican"]=@"mexican";
    
    self.sortByYelpKeys=[[NSMutableDictionary alloc] init];
    self.sortByYelpKeys[@"best match"]=@0;
    self.sortByYelpKeys[@"distance"]=@1;
    self.sortByYelpKeys[@"highest Rated"]=@2;
    
    
    
    UINib *customCellNib= [UINib nibWithNibName:@"YelpTableViewCell" bundle:nil];
    [self.tableView registerNib:customCellNib forCellReuseIdentifier:@"YelpTableViewCell"];
    
    self.stubCell= [self.tableView dequeueReusableCellWithIdentifier:@"YelpTableViewCell"];
    
    [self loadData];
    
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    if (self.businesses.count - 1 == indexPath.row){
//        NSLog(@"Searching with more radius for inifinite scrolling");
//        self.filtersView.optionsChosen[@"SortBy"]=@"";
//        self.filtersView.optionsChosen[@"Distance"]=@"4000 meters";
//        self.filtersView.optionsChosen[@"Categories"] = @"";
//        [self searchUsingFilters];
//    }
//}



#pragma mark - TableView meethods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpTableViewCell" forIndexPath:indexPath];
    
    //Not sure why this method was called before load data was complete .. hence the chek
    if (self.businesses.count > 0)
    {
        cell.business = self.businesses[indexPath.row];

        //[cell initializeCell:self.businesses[indexPath.row] withIndex:indexPath.row+1];
            NSLog(@"initi called");
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self configureCell:_stubCell atIndexPath:indexPath];
    //[stubCell layoutSubviews];

    //CGSize size = [stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    NSLog(@"Height called");
    self.stubCell.business = self.businesses[indexPath.row];
    [self.stubCell layoutSubviews];
    
    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
 
    NSLog(@"--> height: %f", size.height);
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;

}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YelpBusiness *biz = self.businesses[indexPath.row];
    int nameLabelWidth=175;
    float addheight;
    float nameHeight;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        nameLabelWidth = 450;
        addheight = 30;
    }
    
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        nameLabelWidth=175;
    }
    
    NSString *name = biz.name;
    UIFont *font = [UIFont boldSystemFontOfSize: 17];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [name boundingRectWithSize:CGSizeMake(nameLabelWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    nameHeight = rect.size.height;
   // NSLog(@" \n\n                                      NAme %@ height %f ",name, nameHeight);
    
    NSString *add = biz.address;
    CGRect rect1 = [add boundingRectWithSize:CGSizeMake(nameLabelWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGSize maximumSize = CGSizeMake(200, 9999);
    CGSize myStringSize = [add sizeWithFont:font
                               constrainedToSize:maximumSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"My size %f",myStringSize.height);
    
    addheight += rect1.size.height;
    
    
    float cellheight = 48 + addheight + nameHeight;
    NSLog(@"\n\n----                    %f            %@ -height: %f\n",cellheight ,add,addheight);
    
    
   // NSLog(@"\n\n %f",cellheight);
    return cellheight;

}
*/

#pragma mark - Search meethods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //self.filtersView.optionsChosen[@"Deals"]=@"";
    self.filtersView.optionsChosen[@"SortBy"]=@"";
    self.filtersView.optionsChosen[@"Distance"]=@"";
    self.filtersView.optionsChosen[@"Categories"] = @"";
    [searchBar resignFirstResponder];
    // Do the search...
    if(searchBar.text.length>0) {
        self.searchKey = searchBar.text;
        [self loadData];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - private

- (void)loadData{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    [self.client searchWithTerm:self.searchKey success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"API CALL SUCCESS");
        
        [self.businesses removeAllObjects];
        
        for (NSDictionary *businessDictionaryObj in [response objectForKey:@"businesses"] ) {
            [self.businesses addObject:[[YelpBusiness alloc]initWithBusinessData:businessDictionaryObj]];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (IBAction)onFilterButton:(id)sender {
    self.filtersView.optionsChosen[@"Deals"]=self.optionsChosen[@"Deals"];
    self.filtersView.optionsChosen[@"SortBy"]=self.optionsChosen[@"SortBy"];
    self.filtersView.optionsChosen[@"Distance"]=self.optionsChosen[@"Distance"];
    self.optionsChosen[@"Categories"]=@"";

    self.filtersView.optionsChosen[@"Categories"]=self.optionsChosen[@"Categories"];
    
    [self.navigationController pushViewController:self.filtersView animated:YES];
}


#pragma mark - FiltersViewControllerDelegate

- (void)setDealsInSearch:(NSString* )onOff {
    self.optionsChosen[@"Deals"]=onOff;
}

- (void)sortByInSearch:(NSString *)sortBy {
    self.optionsChosen[@"SortBy"]=sortBy;
}

- (void)distanceInSearch:(NSString *)distance {
    self.optionsChosen[@"Distance"]=distance;
}

- (void)categoriesInSearch:(NSString *)categories {
    self.optionsChosen[@"Categories"]=categories;
}


- (void)searchUsingFilters {

    NSString *dealsChosen=[self.optionsChosen[@"Deals"] isEqualToString:@"off"] ? @"false": @"true";
    NSLog(@"Deal Flag: %@",dealsChosen);
   
    if (self.categoriesYelpKeys[ self.optionsChosen[@"Categories"]]) {
          NSLog(@"Categories : %@",  self.optionsChosen[@"Categories"]);
        self.searchKey = self.optionsChosen[@"Categories"];
    }
    self.searchBar.text = self.searchKey;
     NSLog(@"Search worrd:%@", self.searchKey);
    MBProgressHUD *hub = [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"Loading....";
    
    [self.client searchWithTerm:self.searchKey withDeals:dealsChosen sortBy:self.sortByYelpKeys[self.optionsChosen[@"SortBy"]]
                       inRadius:[self.optionsChosen[@"Distance"] intValue] inCategory:self.categoriesYelpKeys[ self.optionsChosen[@"Categories"]] success:^(AFHTTPRequestOperation *operation, id response) {
                               NSLog(@"API with filters called Successfuly");
                           
                           for (NSDictionary *businessDictionaryObj in [response objectForKey:@"businesses"] ) {
                               [self.businesses addObject:[[YelpBusiness alloc]initWithBusinessData:businessDictionaryObj]];
                               
                           }
                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                           [self.tableView reloadData];
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"error: %@", [error description]);
                        //   [MBProgressHUD hideHUDForView:self.view animated:YES];
                       }];

}

- (void) searchButtonClicked {
    [self.businesses removeAllObjects];
    [self searchUsingFilters];
}
@end
