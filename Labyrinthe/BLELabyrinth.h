//
//  BLELabyrinth.h
//  Labyrinthe
//
//  Created by Anaïs Paillette on 05/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE.h"

@interface BLELabyrinth : NSObject<BLEDelegate>

@property (strong, nonatomic) BLE *bleShield;

+ (id)sharedInstance;

- (void) startConnection;
- (void) didConnectwithCompletionHandler:(void(^)())handler orDidFail:(void(^)())errorHandler;
- (void) didDisconnectwithCompletionHandler:(void(^)())handler;
- (void) didReceiveAuthorizationToWrite:(void(^)())handler;
- (void) writeMessage:(NSString *)message;

@end
