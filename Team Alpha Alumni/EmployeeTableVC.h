//
//  EmployeeTableVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeTableVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *employees;

@property (nonatomic, strong) NSString *companyName;

- (IBAction)SelectedSearchButton:(id)sender;

@end
