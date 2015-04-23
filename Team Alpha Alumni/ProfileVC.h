//
//  ProfileVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *WorkLabel;

@property (weak, nonatomic) IBOutlet UITextView *RoleText;

@property (weak, nonatomic) IBOutlet UITextView *StartingYearText;

@property (weak, nonatomic) IBOutlet UITextView *LocationText;

@property (weak, nonatomic) IBOutlet UITextView *FavoriteMemoryText;

@property (weak, nonatomic) IBOutlet UITextView *ExperienceText;

@end
