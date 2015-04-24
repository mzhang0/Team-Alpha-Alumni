//
//  YearSelectionTableVC.m
//  Team Alpha Alumni
//
//

#import "YearSelectionTableVC.h"
#import "YearSelectionTableViewCell.h"
#import "ProfileCollectionVC.h"

@interface YearSelectionTableVC ()

@end

@implementation YearSelectionTableVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.people);
    
    NSMutableArray *yearCollection = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [self.people count]; i++) {

        NSNumber *year = [self.people[i] objectForKey:@"year"];
        [yearCollection addObject:year];
    }
    
    [yearCollection addObject:[NSNumber numberWithInt:0]];
    
    //Removes duplicates.
    self.years = [[NSSet setWithArray:yearCollection] allObjects];
    
    //Sorts array in descending order.
    self.years = [[[self.years sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
    
    NSLog(@"%@", self.years);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        
            NSPredicate *yearMatch = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *alumnusInformation, NSDictionary *bindings) {
            
                NSNumber *startYear = [alumnusInformation objectForKey:@"year"];
                return [year isEqualToNumber:startYear];
            }];
        
            profileCollectionController.filteredPeople = [self.people filteredArrayUsingPredicate:yearMatch];
        }
        
        profileCollectionController.selectedYear = year;
        
        NSLog(@"%@", profileCollectionController.filteredPeople);
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}


@end
