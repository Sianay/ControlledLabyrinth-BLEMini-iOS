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
        
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Echec de la connexion"
                                                         message:@"Impossible de se connecter au BLE Mini"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [dialog show];
        
        
    }];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [[BLELabyrinth sharedInstance] didDisconnectwithCompletionHandler:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectionAction:(id)sender {
    [self.activityIndicator startAnimating];
   [[BLELabyrinth sharedInstance] startConnection];
    
   //[self performSegueWithIdentifier:@"pushToGame" sender:self];

}





@end
