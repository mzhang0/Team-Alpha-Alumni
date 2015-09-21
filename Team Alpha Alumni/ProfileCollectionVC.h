//
//  ProfileCollectionVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCollectionVC : UICollectionViewController

@property (strong, nonatomic) NSArray *filteredPeople;
@property (weak, nonatomic) NSArray *people;
@property (strong, nonatomic) NSNumber *selectedYear;

- (IBAction)SelectedSearchButton:(id)sender;

@end
