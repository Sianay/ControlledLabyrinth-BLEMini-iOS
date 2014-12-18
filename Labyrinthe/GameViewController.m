//
//  ViewController.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import "GameViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "MotionManager.h"

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@interface GameViewController (){
    BOOL authorizeToSend;
}


@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStopState];
    
    self.motionView.layer.cornerRadius = 50;
    
    UITapGestureRecognizer *touchOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBall)] ;
    
    // Set required taps and number of touches
    [touchOnView setNumberOfTapsRequired:1];
    [touchOnView setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [self.motionView addGestureRecognizer:touchOnView];
    
    [[BLELabyrinth sharedInstance] didReceiveAuthorizationToWrite:^{
        authorizeToSend = YES;
    }];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    // [[BLELabyrinth sharedInstance] bleShield].delegate = self;
}

-(void) touchBall{
    [self startMyMotionDetect];
}

- (IBAction)stopAction:(id)sender {
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.motionView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }
                     completion:^(BOOL finished){
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                         
                         self.motionView.center = self.view.center;
                         self.motionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         
                         [self setStopState];
                         
                         [[[MotionManager sharedInstance] motionManager] stopAccelerometerUpdates];
                         [[[MotionManager sharedInstance] motionManager] stopDeviceMotionUpdates];
                         
                         
                         
                         
                     }];
}

-(void) setStopState{
    
    self.startLabel.hidden = NO;
    self.stopButton.hidden = YES;
    authorizeToSend = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[[MotionManager sharedInstance] motionManager] stopAccelerometerUpdates];
    [[[MotionManager sharedInstance] motionManager] stopDeviceMotionUpdates];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startMyMotionDetect
{
    __block float stepMoveFactor = 15;
    
    self.startLabel.hidden = YES;
    self.stopButton.hidden = NO;
    
    [[[MotionManager sharedInstance] motionManager] startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            CGRect rect = self.motionView.frame;
                            
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
                             completion:nil];
                            


                            
                        });
     }
     ];
    
    
    [[[MotionManager sharedInstance] motionManager] startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            
                            if (authorizeToSend){
                                
                                [self sendAccelerometerDataToBLEMiniX:radiansToDegrees(motion.attitude.roll) andY:radiansToDegrees(motion.attitude.pitch)];
                            }
                            
                        });
     }
     ];
    
}

-(void) sendAccelerometerDataToBLEMiniX:(double) xAcceleration andY:(double) yAcceleration{
    
    NSString *message = [NSString stringWithFormat:@"%d,%d/",(int)xAcceleration, (int)yAcceleration];
    
    NSLog(@"send : %@",message);
    
    [[BLELabyrinth sharedInstance] writeMessage:message];
    
    authorizeToSend = NO;
}

@end
