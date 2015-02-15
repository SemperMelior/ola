//
//  SearchNavigationController.m
//  Ola
//
//  Created by Justin Womersley on 2/15/15.
//  Copyright (c) 2015 cs147. All rights reserved.
//

#import "SearchNavigationController.h"
#import "FoodItemsTVC.h"

@interface SearchNavigationController ()

@end

@implementation SearchNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(self.foodName != nil && self.numberOfCarbs != nil) {
        NSArray *itemData = @[self.foodName, self.numberOfCarbs];
        [self.delegate sendDataToFoodItemsTVC:itemData];
    }
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
