//
//  CompaniesTableVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompaniesTableVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *CompaniesTableViewActivityIndicator;

@property (strong, nonatomic) NSArray *people;

@property (strong, nonatomic) NSArray *companies;

- (IBAction)SelectedSearchButton:(id)sender;

@end
