//
//  ProfileVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "ProfileVC.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile", self.Alumnus.name];
    
    dispatch_queue_t queue = dispatch_queue_create("load profile image", 0);
    dispatch_async(queue, ^{
        
        NSURL *url = [NSURL URLWithString:self.Alumnus.photo];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.ProfileImage.image = image;
        });
    });
    
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
