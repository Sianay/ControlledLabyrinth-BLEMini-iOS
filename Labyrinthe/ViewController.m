//
//  ViewController.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "MotionManager.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.motionView.layer.cornerRadius = 50;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self startMyMotionDetect];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[[MotionManager sharedInstance] motionManager] stopAccelerometerUpdates];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startMyMotionDetect
{
    __block float stepMoveFactor = 15;
    
    [[[MotionManager sharedInstance] motionManager] startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *data, NSError *error)
     {

        // self.xLabel.text = [NSString stringWithFormat:@"X : %f",data.acceleration.x];
        // self.yLabel.text = [NSString stringWithFormat:@"Y : %f",data.acceleration.y];
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            
                             
                            CGRect rect = self.motionView.frame;
                            
                            float movetoX = rect.origin.x + (data.acceleration.x * stepMoveFactor);
                            float maxX = self.view.frame.size.width - rect.size.width;
                            
                            float movetoY = (rect.origin.y + rect.size.height) - (data.acceleration.y * stepMoveFactor);
                            float maxY = self.view.frame.size.height;
                            
                            if ( movetoX > 0 && movetoX < maxX ) {rect.origin.x += (data.acceleration.x * stepMoveFactor);};
                            if ( movetoY > rect.size.height && movetoY < maxY ) {rect.origin.y -= (data.acceleration.y * stepMoveFactor);};
                            
                            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:
                             ^{
                                 self.motionView.frame = rect;
  
                             }
                                             completion:nil
                             
                             ];
                            
                        });
     }
     ];
    
    
}

@end
