//
//  ViewController.h
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLELabyrinth.h"

@interface GameViewController : UIViewController<BLEDelegate>


@property (weak, nonatomic) IBOutlet UIView *motionView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;


@end

