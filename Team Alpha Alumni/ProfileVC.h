//
//  ProfileVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface ProfileVC : UIViewController

@property (strong, nonatomic) Person *alumnus;

@property (weak, nonatomic) NSArray *people;

@property BOOL isSearchResultProfile;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *WorkLabel;

@property (weak, nonatomic) IBOutlet UITextView *RoleText;

@property (weak, nonatomic) IBOutlet UITextView *StartingYearText;

@property (weak, nonatomic) IBOutlet UITextView *LocationText;

@property (weak, nonatomic) IBOutlet UITextView *FavoriteMemoryText;

@property (weak, nonatomic) IBOutlet UITextView *ExperienceText;

@property (weak, nonatomic) IBOutlet UILabel *FavoriteMemoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *ExperienceLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *SearchButton;

- (IBAction)SelectedSearchButton:(id)sender;

@end
