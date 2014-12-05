//
//  BLELabyrinth.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 05/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import "BLELabyrinth.h"

@interface BLELabyrinth()

@property (nonatomic, strong) void(^didConnectcompletionHandler)();
@property (nonatomic, strong) void(^didFailcompletionHandler)();

@end

@implementation BLELabyrinth
@synthesize bleShield;

static BLELabyrinth *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (BLELabyrinth *)sharedInstance {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        bleShield = [[BLE alloc] init];
        [bleShield controlSetup];
        bleShield.delegate = self;
    }
    
    return self;
}

- (void) startConnection{
    
    if ([[BLELabyrinth sharedInstance] bleShield].activePeripheral)
        if([[BLELabyrinth sharedInstance] bleShield].activePeripheral.isConnected)
        {
            [[[[BLELabyrinth sharedInstance] bleShield] CM] cancelPeripheralConnection:[[[BLELabyrinth sharedInstance] bleShield] activePeripheral]];
            return;
        }
    
    if ([[BLELabyrinth sharedInstance] bleShield].peripherals)
        [[BLELabyrinth sharedInstance] bleShield].peripherals = nil;
    
    [[[BLELabyrinth sharedInstance] bleShield] findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

-(void) connectionTimer:(NSTimer *)timer
{
    if([[BLELabyrinth sharedInstance] bleShield].peripherals.count > 0)
    {
        [[[BLELabyrinth sharedInstance] bleShield] connectPeripheral:[[[BLELabyrinth sharedInstance] bleShield].peripherals objectAtIndex:0]];
    }
    else
    {
        _didFailcompletionHandler();
    }
}

- (void) didConnectwithCompletionHandler:(void(^)())handler orDidFail:(void(^)())errorHandler{
    _didConnectcompletionHandler = handler;
    _didFailcompletionHandler = errorHandler;
}


#pragma mark - BLE delegate

-(void) bleDidConnect
{
    _didConnectcompletionHandler();
    
}




@end
