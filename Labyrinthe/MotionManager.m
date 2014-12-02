//
//  MotionManager.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import "MotionManager.h"

@interface MotionManager ()


@end

@implementation MotionManager

static MotionManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (MotionManager *)sharedInstance {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.motionManager = [[CMMotionManager alloc] init];
        
    }
    
    return self;
}



@end
