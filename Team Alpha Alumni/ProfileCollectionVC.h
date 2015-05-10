//
//  ProfileCollectionVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCollectionVC : UICollectionViewController

@property (strong, nonatomic) NSArray *filteredPeople;
@property (strong, nonatomic) NSNumber *selectedYear;

@end
