//
//  ProfileVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "ProfileVC.h"
#import "AsynchronousLoading.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile", self.Alumnus.name];
    
    NSURL *url = self.Alumnus.photo;
    
    [AsynchronousLoading loadImageFromUrl:url completion:^(UIImage *image, NSError *error){
        if (!error)
            self.ProfileImage.image = image;
        else
            NSLog(@"Error: %@", error);
    }];
    
    self.NameLabel.text = self.Alumnus.name;
    self.WorkLabel.text = self.Alumnus.position;
    self.RoleText.text = self.Alumnus.role;
    self.StartingYearText.text = [self.Alumnus.startYear stringValue];
    
    self.LocationText.text = self.Alumnus.location;
    self.FavoriteMemoryText.text = self.Alumnus.memory;
    self.ExperienceText.text = self.Alumnus.experience;
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

@end
