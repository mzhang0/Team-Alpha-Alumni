//
//  ProfileVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "ProfileVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile", self.alumnus.name];
    
    NSURL *url = [NSURL URLWithString:self.alumnus.photo];
    [self.ProfileImage sd_setImageWithURL:url placeholderImage:nil];
    
    NSMutableString *workInformation = [[NSMutableString alloc] init];

    for (NSUInteger i = 0; i < self.alumnus.work.count; i++) {
        NSDictionary *workEntry = [self.alumnus.work objectAtIndex:i];
        
        NSString *position = [workEntry objectForKey:@"position"];
        NSString *company = [workEntry objectForKey:@"company"];
        
        if ([company isEqualToString:@""])
            [workInformation appendFormat:@"%@", position];
        else
            [workInformation appendFormat:@"%@ at %@", position, company];
        
        if (i < self.alumnus.work.count - 1)
            [workInformation appendString:@", "];
    }
    
    self.NameLabel.text = self.alumnus.name;
    self.WorkLabel.text = workInformation;
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

@end
