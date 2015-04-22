//
//  ProfileCollectionVC.h
//  Team Alpha Alumni
//
//  Created by JBravo on 4/19/15.
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCollectionVC : UICollectionViewController

@property (strong, nonatomic) NSArray *filteredPeople;
@property (strong, nonatomic) NSMutableArray *fullNames;
@property (strong, nonatomic) NSMutableArray *thumbnailURLs;
@property (strong, nonatomic) NSCache *thumbnailCache;

@end
