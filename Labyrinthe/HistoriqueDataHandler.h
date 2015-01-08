//
//  HistoriqueDataHandler.h
//  Labyrinthe
//
//  Created by Anaïs Paillette on 08/01/2015.
//  Copyright (c) 2015 ARLEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoriqueDataHandler : NSObject

+ (id)sharedInstance;
-(void) writeData:(NSString*) pseudo numberHole:(NSString*) trou;
- (NSDictionary*) readData;

@end
