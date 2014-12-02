//
//  ViewController.h
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *xProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *yProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *zProgressView;
@property (weak, nonatomic) IBOutlet UIView *motionView;
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;

@end

