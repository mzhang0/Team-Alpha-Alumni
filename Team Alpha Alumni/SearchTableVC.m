//
//  SearchTableVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "SearchTableVC.h"
#import "ProfileVC.h"
#import "SearchTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchTableVC ()

@end

@implementation SearchTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.people) {
        
        [self loadPeople];
        [self.SearchTableActivityIndicator startAnimating];
    }
    else {
        
        self.people = [self.people sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        [self initializeSearchController];
    }
}

- (void)initializeSearchController {
    
    self.tableView.estimatedRowHeight = 90.0;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1.0f];
    self.searchController.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Name", @"Location", @"Position", @"Company", nil];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    [self.searchController.searchBar sizeToFit];
    
    self.searchController.active = YES;
}

- (void)loadPeople {
    
    RKObjectRequestOperation *objectRequestOperation = [Person getObjectRequestOperation];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.people = [mappingResult.array sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        RKLogInfo(@"Loaded people:\n %@", self.people);
        [self initializeSearchController];
        [self.SearchTableActivityIndicator stopAnimating];
        [self.tableView reloadData];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
              
        RKLogError(@"Error: %@", error);
              
        //Displays the error to the user
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[error localizedDescription] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
              
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [objectRequestOperation start];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active)
        return self.filteredPeople.count;
    return self.people.count;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    UIView *colorView = [[UIView alloc] init];
    colorView.backgroundColor = [UIColor colorWithRed:118/255.0f green:118/255.0f blue:118/255.0f alpha:1.0f];
    cell.selectedBackgroundView =  colorView;
    
    Person *individual;
    if (self.searchController.active)
        individual = [self.filteredPeople objectAtIndex:indexPath.row];
    else
        individual = [self.people objectAtIndex:indexPath.row];
    
    [cell.ThumbnailView sd_setImageWithURL:[NSURL URLWithString:individual.thumbnail] placeholderImage:nil];
    
    if ([individual.location isEqualToString:@""]) {
        cell.NameLocationLabel.text = individual.name;
        cell.WorkLabel.text = nil;
    }
    else {
        cell.NameLocationLabel.text = [NSString stringWithFormat:@"%@ - %@", individual.name, individual.location];
        cell.WorkLabel.text = individual.getFormattedWorkInformation;
    }
    return cell;
}

#pragma mark - Search delegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
    [searchBar becomeFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = [self.searchController.searchBar text];
    
    NSUInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
    NSString *scope = [self.searchController.searchBar.scopeButtonTitles objectAtIndex:selectedScopeButtonIndex];
    
    [self updateFilteredContent:searchText forScope:scope];
    
    [self.tableView reloadData];
}

- (void)updateFilteredContent:(NSString *)searchText forScope:(NSString *)scope {
    
    if (searchText == nil || searchText.length == 0) {
        self.filteredPeople = [self.people mutableCopy];
        return;
    }
    
    [self.filteredPeople removeAllObjects];
    
    for (Person *individual in self.people) {
        if ([scope isEqualToString:@"Name"]) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange range = NSMakeRange(0, individual.name.length);
            NSRange foundRange = [individual.name rangeOfString:searchText options:searchOptions range:range];
            if (foundRange.length > 0)
                [self.filteredPeople addObject:individual];
        }
        else if ([scope isEqualToString:@"Location"]) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange range = NSMakeRange(0, individual.location.length);
            NSRange foundRange = [individual.location rangeOfString:searchText options:searchOptions range:range];
            if (foundRange.length > 0)
                [self.filteredPeople addObject:individual];
        }
        else if ([scope isEqualToString:@"Position"]) {
            BOOL matched = NO;
            NSUInteger i = 0;
            
            while (!matched && i < individual.work.count) {
                NSString *position = [[individual.work objectAtIndex:i] objectForKey:@"position"];
                
                NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
                NSRange range = NSMakeRange(0, position.length);
                NSRange foundRange = [position rangeOfString:searchText options:searchOptions range:range];
                
                if (foundRange.length > 0) {
                    [self.filteredPeople addObject:individual];
                    matched = YES;
                }
                i++;
            }
        }
        else {
            BOOL matched = NO;
            NSUInteger i = 0;
            
            while (!matched && i < individual.work.count) {
                NSString *company = [[individual.work objectAtIndex:i] objectForKey:@"company"];
                
                NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
                NSRange range = NSMakeRange(0, company.length);
                NSRange foundRange = [company rangeOfString:searchText options:searchOptions range:range];
                
                if (foundRange.length > 0) {
                    [self.filteredPeople addObject:individual];
                    matched = YES;
                }
                i++;
            }
        }
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"ShowProfileFromSearch"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (self.searchController.isActive)
            self.selectedPerson = self.filteredPeople[indexPath.row];
        else
            self.selectedPerson = self.people[indexPath.row];
        
        if ([self.selectedPerson.location isEqualToString:@""])
            return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowProfileFromSearch"]) {
        
        ProfileVC *profileController = segue.destinationViewController;
        profileController.alumnus = self.selectedPerson;
    }
}

@end
