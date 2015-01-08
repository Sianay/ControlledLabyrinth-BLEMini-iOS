//
//  HistoriqueDataHandler.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 08/01/2015.
//  Copyright (c) 2015 ARLEM. All rights reserved.
//

#import "HistoriqueDataHandler.h"

@implementation HistoriqueDataHandler

static HistoriqueDataHandler *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (HistoriqueDataHandler *)sharedInstance {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


- (id)init {
    self = [super init];
    if (self) {
        [self createFile];
    }
    
    return self;
}

- (void) createFile{
    
    NSString *path = [HistoriqueDataHandler getPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        NSMutableDictionary *data = [NSMutableDictionary new];
        [data setObject:[[NSMutableArray alloc] init] forKey:@"tab"];
        [data writeToFile:path atomically:YES];
    }
}

+ (NSString*) getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"historique.plist"];
    
    return path;
    
}

- (void) writeData:(NSString*) pseudo numberHole:(NSString*) hole{
    
    NSString *path = [HistoriqueDataHandler getPath];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray *tab = [data objectForKey:@"tab"];
    
    NSDictionary *row = @{@"pseudo":pseudo,@"date":[NSDate date],@"hole":hole};
    
    [tab addObject:row];
    [data setObject:tab forKey:@"tab"];
    
    [data writeToFile:path atomically:YES];
    
}


- (NSDictionary*) readData {
    return [[NSMutableDictionary alloc] initWithContentsOfFile:[HistoriqueDataHandler getPath]];
    
}


@end
