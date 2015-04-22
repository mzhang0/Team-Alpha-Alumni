//
//  ProfileCollectionVC.m
//  Team Alpha Alumni
//
//  Created by JBravo on 4/19/15.
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "ProfileCollectionVC.h"
#import "ProfileCollectionViewCell.h"

@interface ProfileCollectionVC ()

@end

@implementation ProfileCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fullNames = [[NSMutableArray alloc] init];
    self.thumbnailURLs = [[NSMutableArray alloc] init];
    self.thumbnailCache = [[NSCache alloc] init];
    
    for (NSInteger i = 0; i < [self.filteredPeople count]; i++) {
        
        NSURL *url = [NSURL URLWithString:[self.filteredPeople[i] objectForKey:@"thumbnail"]];
        
        NSString *firstName = [self.filteredPeople[i] objectForKey:@"first"];
        NSString *lastName = [self.filteredPeople[i] objectForKey:@"last"];
        
        [self.thumbnailURLs addObject:url];
        [self.fullNames addObject:[NSString stringWithFormat: @"%@ %@", firstName, lastName]];
    }
    
    NSLog(@"%@", self.filteredPeople);
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredPeople.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *thumbnailName = [NSString stringWithFormat:@"%@ thumb", self.fullNames[indexPath.row]];
    
    // Configure the cell
    
    cell.NameLabel.text = [self.fullNames objectAtIndex:indexPath.row];
    
    [cell.ThumbnailButton setBackgroundImage:nil forState:UIControlStateNormal];
     
    if ([self.thumbnailCache objectForKey:thumbnailName] != nil)
        [cell.ThumbnailButton setBackgroundImage:[self.thumbnailCache objectForKey:thumbnailName] forState:UIControlStateNormal];
    else {
        
        dispatch_queue_t queue = dispatch_queue_create("load thumbnails", 0);
        dispatch_async(queue, ^{
            
            NSURL *url = [self.thumbnailURLs objectAtIndex:indexPath.row];
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            UIImage *thumbnailImage = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cell.ThumbnailButton setBackgroundImage:thumbnailImage forState:UIControlStateNormal];
                [self.thumbnailCache setObject:thumbnailImage forKey:thumbnailName];
            });
        });
    }
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

@end
