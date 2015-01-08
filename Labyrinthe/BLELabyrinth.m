//
//  BLELabyrinth.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 05/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import "BLELabyrinth.h"

@interface BLELabyrinth(){
}

@property (nonatomic, strong) void(^didConnectcompletionHandler)();
@property (nonatomic, strong) void(^didFailcompletionHandler)();
@property (nonatomic, strong) void(^didReceiveAuthorizationToWrite)();
@property (nonatomic, strong) void(^didReceiveNumberHole)(NSString* numberHole);
@property (nonatomic, strong) void(^didDisconnectcompletionHandler)();

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
    
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:bleShield.activePeripheral];
        }
    
    if ([[BLELabyrinth sharedInstance] bleShield].peripherals)
        [[BLELabyrinth sharedInstance] bleShield].peripherals = nil;
    
    [[[BLELabyrinth sharedInstance] bleShield] findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

- (void) endConnection {
    
    if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
    {
        [[bleShield CM] cancelPeripheralConnection:bleShield.activePeripheral];
    }
    
    if ([[BLELabyrinth sharedInstance] bleShield].peripherals)
        [[BLELabyrinth sharedInstance] bleShield].peripherals = nil;
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

- (void) didReceiveAuthorizationToWrite:(void(^)())handler orNumberHole:(void(^)(NSString* numberHole))numberHandler{
    _didReceiveAuthorizationToWrite = handler;
    _didReceiveNumberHole = numberHandler;
}

- (void) didDisconnectwithCompletionHandler:(void(^)())handler{
    _didDisconnectcompletionHandler = handler;
}

- (void) writeMessage:(NSString *)message {
    
    NSData *d = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    [bleShield write:d];
    
}

#pragma mark - BLE delegate

-(void) bleDidConnect{
    _didConnectcompletionHandler();
    
}

-(void) bleDidDisconnect{
    if (_didDisconnectcompletionHandler != nil){
            _didDisconnectcompletionHandler();
    }
}


-(void) bleDidReceiveData:(unsigned char *) data length:(int) length{
    
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"data : %@",s);
    
    if ([s containsString:@"go"]){
        _didReceiveAuthorizationToWrite();
    }else if ([s hasPrefix:@"#"]){
        _didReceiveNumberHole([s stringByReplacingOccurrencesOfString:@"#" withString:@""]);
    }

    
}


@end
