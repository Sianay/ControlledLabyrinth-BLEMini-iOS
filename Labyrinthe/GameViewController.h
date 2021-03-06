//
//  ViewController.h
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLELabyrinth.h"
#import "SphereMenu.h"

@interface GameViewController : UIViewController<BLEDelegate,SphereMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *motionView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;


@end

