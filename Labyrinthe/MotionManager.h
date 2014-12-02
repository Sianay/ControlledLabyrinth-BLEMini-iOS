//
//  MotionManager.h
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MotionManager : NSObject

@property (strong,nonatomic) CMMotionManager *motionManager;
+ (id)sharedInstance;

@end
