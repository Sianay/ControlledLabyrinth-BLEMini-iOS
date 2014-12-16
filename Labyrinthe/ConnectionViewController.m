//
//  ConnectionViewController.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 05/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import "ConnectionViewController.h"
#import "BLELabyrinth.h"

@interface ConnectionViewController ()


@end

@implementation ConnectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BLELabyrinth sharedInstance] didConnectwithCompletionHandler:^{
        [self.activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"pushToGame" sender:self];
        NSLog(@"right!");
    } orDidFail:^{
        [self.activityIndicator stopAnimating];
        NSLog(@"fail");
    }];
    
}

-(void) viewWillAppear:(BOOL)animated {
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

- (IBAction)connectionAction:(id)sender {
    [self.activityIndicator startAnimating];
    [[BLELabyrinth sharedInstance] startConnection];
}





@end
