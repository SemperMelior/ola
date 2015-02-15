//
//  FoodItemsTVC.m
//  Ola
//
//  Created by Albert Chen on 11/21/14.
//  Copyright (c) 2014 cs147. All rights reserved.
//

#import "FoodItemsTVC.h"
#import <CommonCrypto/CommonDigest.h>
#import "CustomIOS7AlertView.h"
#import "InsulinInjectionVC.h"
#import "SearchNavigationController.h"

@interface FoodItemsTVC ()

@property (strong, nonatomic) NSMutableArray *fooditems;
@property (weak, nonatomic) IBOutlet UITableView *foodNameTableView;
@property (strong, nonatomic) CustomIOS7AlertView *foodNameAlertView;
@property (strong, nonatomic) NSMutableArray *foodNames;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *calculateButton;

@end

@implementation FoodItemsTVC

@synthesize totalCarbs = _totalCarbs; // because we provide setter AND getter

- (NSUInteger)totalCarbs
{
    _totalCarbs = 0;
    for(int i = 0; i < [self numFoodItems]; i++) {
        FoodItem *fi = [self foodItemAtIndex:i];
        _totalCarbs += fi.carbCount;
    }
    return _totalCarbs;
}

- (void)setTotalCarbs:(NSUInteger)val
{
    _totalCarbs = val;
}

- (void) updateTitle
{
    NSString *newTitle = [NSString stringWithFormat: @"Food Items (%lug)", (unsigned long)self.totalCarbs];
    
    self.title = newTitle;
}

- (NSUInteger) numFoodItems
{
    return [self.fooditems count];
}

- (NSUInteger) numFoodNames
{
    return [self.foodNames count];
}

- (FoodItem *) foodItemAtIndex:(NSInteger) index {
    return [self.fooditems objectAtIndex:index];
}

- (FoodItem *) foodNameAtIndex:(NSInteger) index {
    return [self.foodNames objectAtIndex:index];
}

-(void) removeFoodItemAtIndex:(NSInteger) index {
    [self.fooditems removeObjectAtIndex:index];
    //[self updateTitle];
}

-(void) removeAllFoodItems {
    [self.fooditems removeAllObjects];
    [self.tableView reloadData];
    self.calculateButton.title = @"";
    [self.calculateButton setEnabled:NO];
}

- (void) addFoodItem:(NSString *)name andCarbCount:(NSUInteger)carbCount
{
    FoodItem *fi = [[FoodItem alloc] initWithName:name andCarbCount:carbCount];
    
    [self.fooditems addObject:fi];
    
    [self.tableView reloadData];
    self.calculateButton.title = @"Calculate";
    [self.calculateButton setEnabled:YES];
    //[self updateTitle];
}

- (void) addFoodName:(NSString *)name andCarbCount:(NSUInteger)carbCount
{
    FoodItem *fi = [[FoodItem alloc] initWithName:name andCarbCount:carbCount];
    
    [self.foodNames addObject:fi];
}


- (void)sendDataToFoodItemsTVC:(NSArray *)array
{
    NSString *name = (NSString *)array[0];
    NSNumber *carbs = (NSNumber *)array[1];
    NSUInteger numberOfCarbs = [carbs integerValue];
    [self addFoodItem:name andCarbCount:numberOfCarbs];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tag = 0;
    self.fooditems = [[NSMutableArray alloc] init];
    self.foodNames = [[NSMutableArray alloc] init];
    
    [self addFoodName:@"Apple pie (1 slice)" andCarbCount:50];
    [self addFoodName:@"Beer (1 can)" andCarbCount:13];
    [self addFoodName:@"Cheeseburger" andCarbCount:30];
    [self addFoodName:@"Mapo Tofu" andCarbCount:8];
    [self addFoodName:@"Soft Drink (21 fl oz)" andCarbCount:46];
    
    self.foodNameTableView.tag = 1;
    [self.foodNameTableView setDelegate:self];
    [self.foodNameTableView setDataSource:self];
    
    if([self.fooditems count] < 1) {
        self.calculateButton.title = @"";
        [self.calculateButton setEnabled:NO];
    } else {
        self.calculateButton.title = @"Calculate";
        [self.calculateButton setEnabled:YES];
    }
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
    if(tableView.tag == 0)
        return [self numFoodItems];
    
    if(tableView.tag == 1)
        return [self numFoodNames];
    
    return 0;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(chosenImage)];
    CC_MD5([imageData bytes], (CC_LONG)[imageData length], result);
    NSString *imageHash = [NSString stringWithFormat:
                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    
    unsigned long hashVal = result[0] + result[1] + result[2] + result[3] + result[4] + result[5] + result[6] + result[7] + result[8] + result[9] + result[10] + result[11] + result[12] + result[13] + result[14] + result[15];

    NSLog(@"imageHash: %@", imageHash);
    NSLog(@"imageHash Int: %lu", hashVal);
    NSLog(@"imageHash Int: %lu", (hashVal % 5));
    
    switch(hashVal % 5)
    {
        case 0:
            [self addFoodItem:@"Banana" andCarbCount:27];
            break;
        case 1:
            [self addFoodItem:@"Orange" andCarbCount:11];
            break;
        case 2:
            [self addFoodItem:@"Apple" andCarbCount:25];
            break;
        case 3:
            [self addFoodItem:@"Tomato" andCarbCount:5];
            break;
        case 4:
            [self addFoodItem:@"Pear" andCarbCount:27];
            break;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)handleFoodItemInputTypeAlertView:(UIAlertView *)alertView withButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked 0");
    }
    
    if (buttonIndex == -1)
    {
        NSLog(@"You have clicked food camera!");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    if (buttonIndex == 1)
    {
        NSLog(@"You have clicked carb count!");
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Item Name and Carb Count"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Add", nil];
        
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert textFieldAtIndex:1].secureTextEntry = NO;
        [alert textFieldAtIndex:0].placeholder = @"Item Name";
        [alert textFieldAtIndex:1].placeholder = @"Carb Count";
        [[alert textFieldAtIndex:1] setDelegate:self];
        [alert textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
        alert.tag = 1;
        
        /*
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Forgot Password" message:@"Please enter the email ID associated with your Hngre account." delegate:self cancelButtonTitle:@"Here you go" otherButtonTitles:@"No, thanks", nil];
         alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
         [alert textFieldAtIndex:1].secureTextEntry = NO; //Will disable secure text entry for second textfield.
         [alert textFieldAtIndex:0].placeholder = @"First Placeholder"; //Will replace "Username"
         [alert textFieldAtIndex:1].placeholder = @"Second Placeholder"; //Will replace "Password"
         */
        
        [alert show];
    }
    
    if (buttonIndex == 2)
    {
        NSLog(@"You have clicked food name!");

        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Food Name"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Search", nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].placeholder = @"Food Name";
        alert.tag = 2;
        
        [alert show];
    }
   
}

- (void)handleCarbCountInputAlertView:(UIAlertView *)alertView withButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"You have clicked 0");
    }
    if (buttonIndex == 1) {
        NSLog(@"You have clicked add!");
        NSString *name = [alertView textFieldAtIndex:0].text;
        NSUInteger carbCount = [[alertView textFieldAtIndex:1].text intValue];
        [self addFoodItem:name andCarbCount:(carbCount)];
    }
}

- (void)handleFoodNameInputAlertView:(UIAlertView *)alertView withButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"You have clicked 0");
    }
    if (buttonIndex == 1) {
        NSLog(@"You have clicked search!");
        self.foodNameAlertView = [[CustomIOS7AlertView alloc] init];
        [self.foodNameAlertView setContainerView:self.foodNameTableView];
        [self.foodNameAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", nil]];
        [self.foodNameAlertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0)
        [self handleFoodItemInputTypeAlertView:alertView withButtonIndex:buttonIndex];

    if(alertView.tag == 1)
        [self handleCarbCountInputAlertView:alertView withButtonIndex:buttonIndex];
    
    if(alertView.tag == 2)
        [self handleFoodNameInputAlertView:alertView withButtonIndex:buttonIndex];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView.tag == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Food Item Cell" forIndexPath:indexPath];
    
        FoodItem *fi = [self foodItemAtIndex:indexPath.row];
    
        cell.textLabel.text = fi.name;
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%lu g", (unsigned long)fi.carbCount];
        
        return cell;
    }
    
    if(tableView.tag == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Food Name Cell" forIndexPath:indexPath];
        
        FoodItem *fi = [self foodNameAtIndex:indexPath.row];
        
        cell.textLabel.text = fi.name;
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%lu g", (unsigned long)fi.carbCount];
        
        return cell;
    }
    
    return NULL;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(tableView.tag == 0)
        return YES;
    
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            [self removeFoodItemAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if([self.fooditems count] < 1) {
                self.calculateButton.title = @"";
                [self.calculateButton setEnabled:NO];
            } else {
                self.calculateButton.title = @"Calculate";
                [self.calculateButton setEnabled:YES];
            }
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
 
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView.tag == 1)
    {
        [self.foodNameAlertView close];
        FoodItem *fi = [self foodNameAtIndex:indexPath.row];
        [self addFoodItem:fi.name andCarbCount:fi.carbCount];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


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


- (IBAction)tapNewItemFooterButton:(id)sender {
    //[self newFoodItemTap:sender];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = (UINavigationController *)[sb instantiateViewControllerWithIdentifier:@"AddFoodViewController"];
    nc.delegate = self; // protocol listener
    [self presentViewController:nc animated:YES completion:NULL];
    
}

- (IBAction)newFoodItemTap:(UIBarButtonItem *)sender {

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = (SearchNavigationController *)[sb instantiateViewControllerWithIdentifier:@"AddFoodViewController"];
    nc.delegate = self; // protocol listener
    [self presentViewController:nc animated:YES completion:NULL];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([self numFoodItems] == 0)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No insulin injection required"
                                                         message:@"Add at least 1 food item"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        
        [alert show];

        return NO;
    }
    
    if(self.totalCarbs == 0)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No insulin injection required"
                                                         message:@"Add at least 1g of carb"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        
        [alert show];
        return NO;
    }
    
    if(self.totalCarbs > 800)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                         message:@"Cannot exceed maximum carb count of 800g per meal"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        
        [alert show];

        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"insulin Injection"]) {
        if ([segue.destinationViewController isKindOfClass:[InsulinInjectionVC class]]) {
            InsulinInjectionVC *iivc = (InsulinInjectionVC *)segue.destinationViewController;
            iivc.carbCount = self.totalCarbs;
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= 3));
}


@end
