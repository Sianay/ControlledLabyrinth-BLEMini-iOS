//
//  ConnectionViewController.h
//  Labyrinthe
//
//  Created by Anaïs Paillette on 05/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ConnectionViewController : UIViewController<BLEDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)connectionAction:(id)sender;

@end
