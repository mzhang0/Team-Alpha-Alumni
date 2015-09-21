//
//  ProfileCollectionVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "ProfileCollectionVC.h"
#import "ProfileCollectionViewCell.h"
#import "Person.h"
#import "ProfileVC.h"
#import "SearchTableVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileCollectionVC ()

@end

@implementation ProfileCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.selectedYear isEqualToNumber:[NSNumber numberWithInt:0]])
        self.navigationItem.title = @"All TA Profile Selection";
    else
         self.navigationItem.title = [NSString stringWithFormat:@"%@ TA Profile Selection", self.selectedYear];
    
    NSLog(@"%@", self.filteredPeople);
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"ShowProfile"]) {
        
        //Finds index of selected button
        CGPoint buttonPoint = [sender convertPoint:CGPointZero toView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPoint];
        
        Person *individual = self.filteredPeople[indexPath.row];
        
        if ([individual.location isEqualToString:@""])
            return NO;
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowProfile"]) {
        //Finds index of selected button
        CGPoint buttonPoint = [sender convertPoint:CGPointZero toView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPoint];
        
        ProfileVC *profileController = segue.destinationViewController;
        profileController.alumnus = self.filteredPeople[indexPath.row];
        profileController.people = self.people;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredPeople.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Person *individual = self.filteredPeople[indexPath.row];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:individual.thumbnail];
    [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image)
                [cell.ThumbnailButton setBackgroundImage:image forState:UIControlStateNormal];
        }];
    
    cell.NameLabel.text = individual.name;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (IBAction)SelectedSearchButton:(id)sender {
    
    SearchTableVC *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchController.people = self.people;
    [self.navigationController pushViewController:searchController animated:YES];
}

@end
