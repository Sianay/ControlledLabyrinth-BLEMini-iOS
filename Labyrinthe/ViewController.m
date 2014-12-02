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
    
    UITapGestureRecognizer *touchOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBall)] ;
    
    // Set required taps and number of touches
    [touchOnView setNumberOfTapsRequired:1];
    [touchOnView setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [self.motionView addGestureRecognizer:touchOnView];
    
}


-(void) touchBall{
    [self startMyMotionDetect];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    

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
    
    self.startLabel.hidden = YES;
    
    [[[MotionManager sharedInstance] motionManager] startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            CGRect rect = self.motionView.frame;
                            
                           // NSLog(@"%f %f",data.acceleration.x,data.acceleration.y);
                            
                            float movetoX = rect.origin.x - (data.acceleration.y * stepMoveFactor);
                            float maxX = self.view.frame.size.width - rect.size.width;
                            
                            float movetoY = (rect.origin.y + rect.size.height) - (data.acceleration.x * stepMoveFactor);
                            float maxY = self.view.frame.size.height;
                            
                            if ( movetoX > 0 && movetoX < maxX ) {rect.origin.x -= (data.acceleration.y * stepMoveFactor);};
                            if ( movetoY > rect.size.height && movetoY < maxY ) {rect.origin.y -= (data.acceleration.x * stepMoveFactor);};
                            
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
