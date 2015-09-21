//
//  SearchTableVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface SearchTableVC : UITableViewController <UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *SearchTableActivityIndicator;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *people;
@property (strong, nonatomic) NSMutableArray *filteredPeople;
@property (strong, nonatomic) Person *selectedPerson;

@end
