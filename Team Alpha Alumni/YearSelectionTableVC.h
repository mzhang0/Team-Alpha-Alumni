//
//  YearSelectionTableVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearSelectionTableVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *yearSelectionTableActivityIndicator;

@property (strong, nonatomic) NSArray *people;
@property (strong, nonatomic) NSArray *years;

@end
