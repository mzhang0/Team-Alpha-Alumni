//
//  YearSelectionTableVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "YearSelectionTableVC.h"
#import "YearSelectionTableViewCell.h"
#import "ProfileCollectionVC.h"
#import "Person.h"
#import <RestKit/RestKit.h>

@interface YearSelectionTableVC ()

@end

@implementation YearSelectionTableVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.yearSelectionTableActivityIndicator startAnimating];
    
    [self loadPeople];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadPeople {
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping* personMapping = [RKObjectMapping mappingForClass:[Person class]];
    [personMapping addAttributeMappingsFromDictionary:@{
                                                         @"fullName": @"name",
                                                         @"location": @"location",
                                                         @"work": @"position",
                                                         @"year": @"startYear",
                                                         @"role": @"role",
                                                         @"memory": @"memory",
                                                         @"experience": @"experience",
                                                         @"thumbnail": @"thumbnail",
                                                         @"fullRes" : @"photo"
                                                        }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:personMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/9hk5g1mr558y0zy/Trial3a.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.people = mappingResult.array;
        RKLogInfo(@"Loaded people:\n %@", self.people);
    
        NSMutableArray *yearCollection = [[NSMutableArray alloc] init];

        for (Person *individual in self.people)
            [yearCollection addObject:individual.startYear];

        if (yearCollection.count > 0)
            [yearCollection addObject:[NSNumber numberWithInt:0]];

        //Removes duplicates
        self.years = [[NSSet setWithArray:yearCollection] allObjects];

        //Sorts array in descending order
        self.years = [[[self.years sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];

        [self.yearSelectionTableActivityIndicator stopAnimating];
    
        [self.tableView reloadData];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
      
        [self.yearSelectionTableActivityIndicator stopAnimating];
      
        RKLogError(@"Error: %@", error);
      
        //Displays the error to the user
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[error localizedDescription] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
      
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];

    [objectRequestOperation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.years.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YearSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSNumber *year = self.years[indexPath.row];
    
    if ([year isEqualToNumber:[NSNumber numberWithInt:0]])
        [cell.YearSelectionButton setTitle:@"All Team Alpha Members" forState:UIControlStateNormal];
    else {
        NSString *newTitle = [NSString stringWithFormat:@"%@ Team Alpha Members", year];
        [cell.YearSelectionButton setTitle:newTitle forState:UIControlStateNormal];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowProfileCollection"]) {
        
        ProfileCollectionVC *profileCollectionController = segue.destinationViewController;
                
        //Finds index of the table row containing the selected button
        CGPoint buttonPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPoint];
        
        NSNumber *year = self.years[indexPath.row];
        
        if ([year isEqualToNumber:[NSNumber numberWithInt:0]])
            profileCollectionController.filteredPeople = self.people;
        else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startYear == %@", year];
            profileCollectionController.filteredPeople = [self.people filteredArrayUsingPredicate:predicate];
        }
        
        profileCollectionController.selectedYear = year;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}


@end
