//
//  CompaniesTableVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "CompaniesTableVC.h"
#import "CompanyTableViewCell.h"
#import "Person.h"
#import "EmployeeTableVC.h"
#import "SearchTableVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompaniesTableVC ()

@end

@implementation CompaniesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.CompaniesTableViewActivityIndicator startAnimating];
    
    [self loadPeople];
}

- (void)loadPeople {
    
    RKObjectRequestOperation *objectRequestOperation = [Person getObjectRequestOperation];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.people = mappingResult.array;
        RKLogInfo(@"Loaded people:\n %@", self.people);
        
        NSMutableArray *companyCollection = [[NSMutableArray alloc] init];
        
        for (Person *individual in self.people)
            
            for (NSDictionary *workInformation in individual.work)
                
                if (![[workInformation objectForKey:@"position"] isEqualToString:@"Student"] && ![[workInformation objectForKey:@"logo"] isEqualToString:@""]) {
                    
                    NSMutableDictionary *modifiedWorkInformation = [workInformation mutableCopy];
                    [modifiedWorkInformation removeObjectForKey:@"position"];
                    [companyCollection addObject:modifiedWorkInformation];
                }
        
        //Removes duplicates
        self.companies = [[NSSet setWithArray:companyCollection] allObjects];
        
        //Sorts array in ascending order
        self.companies = [self.companies sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"company" ascending:YES]]];
        
        [self.CompaniesTableViewActivityIndicator stopAnimating];
        
        [self.tableView reloadData];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
      
        [self.CompaniesTableViewActivityIndicator stopAnimating];
      
        RKLogError(@"Error: %@", error);
      
        //Displays the error to the user
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[error localizedDescription] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
      
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [objectRequestOperation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.companies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyCell" forIndexPath:indexPath];
    NSDictionary *company = self.companies[indexPath.row];
    
    // Configure the cell...
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:[company objectForKey:@"logo"]];
    [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image)
                
                [cell.CompanyImageButton setBackgroundImage:image forState:UIControlStateNormal];
        }];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ShowEmployees"]) {
        
        CGPoint buttonPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPoint];
        
        NSString *selectedCompany = [self.companies[indexPath.row] objectForKey:@"company"];
        
        EmployeeTableVC *employeeViewController = segue.destinationViewController;
        employeeViewController.companyName = selectedCompany;
        employeeViewController.employees = [[NSMutableArray alloc] init];

        for (Person *individual in self.people)
            
            for (NSDictionary *workInformation in individual.work)
                
                if (![[workInformation objectForKey:@"position"] isEqualToString:@"Student"] && [[workInformation objectForKey:@"company"] isEqualToString:selectedCompany])
                    
                    [employeeViewController.employees addObject:individual];
    }
}

- (IBAction)SelectedSearchButton:(id)sender {
    
    SearchTableVC *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchController.people = self.people;
    [self.navigationController pushViewController:searchController animated:YES];
}

@end
