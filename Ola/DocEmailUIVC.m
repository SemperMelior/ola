//
//  DocEmailUIVC.m
//  Ola
//
//  Created by Albert Chen on 11/19/14.
//  Copyright (c) 2014 cs147. All rights reserved.
//

#import "DocEmailUIVC.h"
#import "EmailUIVC.h"

@interface DocEmailUIVC ()
@property (weak, nonatomic) IBOutlet UIButton *approvebutton;

@end

@implementation DocEmailUIVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)approveButton:(id)sender {
    NSString *msg = @"";
    
    if([self.approvebutton.currentTitle isEqualToString:@"Approve"])
    {
        msg = @"Are you sure you want to implement this change?";
    } else {
        msg = @"Are you sure you want to undo this change?";
    }
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:msg message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    
    [alert addButtonWithTitle:@"Confirm"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked Confirm");
        
        if([self.approvebutton.currentTitle isEqualToString:@"Approve"])
        {
            [self.approvebutton setTitle:@"Undo" forState:UIControlStateNormal];
        } else {
            [self.approvebutton setTitle:@"Approve" forState:UIControlStateNormal];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"replyEmail"]) {
        if ([segue.destinationViewController isKindOfClass:[EmailUIVC class]]) {
            EmailUIVC *euivc = (EmailUIVC *)segue.destinationViewController;
            euivc.subject = @"RE: Your new bolus ratio";
            euivc.to = @"Dr. Holmes";
        }
    }
}


@end
