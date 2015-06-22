//
//  ProfileVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "ProfileVC.h"
#import "SearchTableVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile", self.alumnus.name];
    
    NSURL *url = [NSURL URLWithString:self.alumnus.photo];
    [self.ProfileImage sd_setImageWithURL:url placeholderImage:nil];
    
    if (self.isSearchResultProfile) {
        self.SearchButton.enabled = NO;
        self.SearchButton.tintColor = [UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1.0f];
    }
    
    if ([self.alumnus.name isEqualToString:@"Will Crawford"]) {
        self.FavoriteMemoryLabel.text = @"Favorite Rule:";
        self.ExperienceLabel.text = @"Random Fact About Me:";
    }
    
    self.NameLabel.text = self.alumnus.name;
    self.WorkLabel.text = self.alumnus.getFormattedWorkInformation;
    self.RoleText.text = self.alumnus.role;
    self.StartingYearText.text = [self.alumnus.startYear stringValue];
    
    self.LocationText.text = self.alumnus.location;
    self.FavoriteMemoryText.text = self.alumnus.memory;
    self.ExperienceText.text = self.alumnus.experience;
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

- (IBAction)SelectedSearchButton:(id)sender {
    
    SearchTableVC *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchController.people = self.people;
    [self.navigationController pushViewController:searchController animated:YES];
}

@end
