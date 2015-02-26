//
//  AddFoodTVC.m
//  Ola
//
//  Created by Justin Womersley on 2/4/15.
//  Copyright (c) 2015 cs147. All rights reserved.
//

#import "AddFoodTVC.h"
#import "SearchNavigationController.h"

@interface AddFoodTVC () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *dataFoodList; // Array was filled with delegation
@property (strong,nonatomic) NSMutableArray *filteredFoodList;
@property IBOutlet UISearchBar *olaSearchBar;
@property (strong, nonatomic) NSString* selectedFoodName;
@property (strong, nonatomic) NSNumber* numberOfCarbs;

@end

@implementation AddFoodTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeThisView:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"convertcsv" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.dataFoodList = [[NSMutableArray alloc] initWithArray:json];
    
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    // Loop through array, removing really long entries..
    for (id object in self.dataFoodList) {
        // do something with object
        NSDictionary *info = (NSDictionary *)object;
        if([info[@"Description"] length] > 39) {
            [discardedItems addIndex:index];
        }
        index++;
    }
    [self.dataFoodList removeObjectsAtIndexes:discardedItems];
    
    self.filteredFoodList = [NSMutableArray arrayWithCapacity:[self.dataFoodList count]];
    [self.olaSearchBar setDelegate:self];
    [self.searchDisplayController setDelegate:self];
    self.searchDisplayController.searchResultsDelegate = self;
}

- (IBAction) closeThisView:(id) sender {
    NSLog(@"Did click close");
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredFoodList count] + 1;
    } else {
        return [self.dataFoodList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = [[NSDictionary alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if(indexPath.row == 0) {
            
        } else {
            info = (NSDictionary *)self.filteredFoodList[indexPath.row - 1];
        }
    } else {
        info = (NSDictionary *)self.dataFoodList[indexPath.row];
    }
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FoodItemIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    if(indexPath.row == 0 && tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"Add custom entry \"%@\"", self.olaSearchBar.text];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Add \"%@\" with your own carb count", self.olaSearchBar.text];
    } else {
        NSLog(@"%@", info);
        CGFloat strFloat = (CGFloat)[info[@"Carbohydrate (g)"] floatValue];
        int grams = (int)strFloat;
        
        // Configure the cell...
        cell.textLabel.text = info[@"Description"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%dg carb, %@", grams, info[@"Measure"]];
    }
    
    return cell;
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"Should ReloadTable - yes!");
    // Return YES to cause the search result table view to be reloaded.
    [self.filteredFoodList removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Description contains[c] %@", searchString];
    self.filteredFoodList = [NSMutableArray arrayWithArray:[self.dataFoodList filteredArrayUsingPredicate:predicate]];
    // Sort by length asc
    NSArray *sortedResults = [self.filteredFoodList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDictionary *info1 = (NSDictionary *)a;
        NSDictionary *info2 = (NSDictionary *)b;
        NSUInteger first = [info1[@"Description"] length];
        NSUInteger second = [info2[@"Description"] length];
        return (first > second);
    }];
    self.filteredFoodList = [NSMutableArray arrayWithArray:sortedResults];
    
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select something?");
    
    NSString *foodName = @"";
    int gramsOfCarbs = 0;
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        if(indexPath.row == 0) {
            foodName = self.olaSearchBar.text;
            gramsOfCarbs = 10;
        } else {
            NSLog(@"IndexPath %ld", (long)indexPath.row);
            NSDictionary *info = (NSDictionary *)self.filteredFoodList[indexPath.row - 1];
            CGFloat strFloat = (CGFloat)[info[@"Carbohydrate (g)"] floatValue];
            gramsOfCarbs = (int)strFloat;
            foodName = info[@"Description"];
        }
    } else {
        NSDictionary *info = (NSDictionary *)self.dataFoodList[indexPath.row];
        CGFloat strFloat = (CGFloat)[info[@"Carbohydrate (g)"] floatValue];
        gramsOfCarbs = (int)strFloat;
        foodName = info[@"Description"];
    }
    
    self.selectedFoodName = foodName;
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"How many grams of carbs?"
                                                     message:[NSString stringWithFormat:@"Estimate the grams of carbohydrates in %@", foodName]
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Add", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"0";
    if(gramsOfCarbs > 0) {
        [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"%d", gramsOfCarbs];
    }
    alert.tag = 0;
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0 && buttonIndex == 1) {
        NSUInteger carbCount = [[alertView textFieldAtIndex:0].text intValue];
        self.numberOfCarbs = [NSNumber numberWithInt:(int)carbCount];
        SearchNavigationController *nc = (SearchNavigationController *)self.navigationController;
        nc.foodName = self.selectedFoodName;
        nc.numberOfCarbs = self.numberOfCarbs;
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
