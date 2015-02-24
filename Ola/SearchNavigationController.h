//
//  SearchNavigationController.h
//  Ola
//
//  Created by Justin Womersley on 2/15/15.
//  Copyright (c) 2015 cs147. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchNavigationControllerDelegate <NSObject>

-(void)sendDataToFoodItemsTVC:(NSArray *)array; // To send data back to FoodItemsTVC

@end

@interface SearchNavigationController : UINavigationController

@property (strong,nonatomic) NSString *foodName;
@property (strong,nonatomic) NSNumber *numberOfCarbs;
@property(nonatomic,assign)id delegate;

@end