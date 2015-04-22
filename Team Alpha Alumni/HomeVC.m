//
//  HomeVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "HomeVC.h"
#import "YearSelectionTableVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Changes the color and tints of the nav bar.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1.0f]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/fac2o3871lm1dsy/Trial1.json"]];
        dispatch_async( dispatch_get_main_queue(), ^{
            self.people = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //NSLog(@"%@",self.people);
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ShowYearSelection"]) {
        YearSelectionTableVC *YearSelectionController = segue.destinationViewController;
        YearSelectionController.people = self.people;

    }
}


@end
