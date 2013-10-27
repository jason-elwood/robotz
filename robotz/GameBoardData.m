//
//  GameBoardData.m
//  robotz
//
//  Created by Jason Elwood on 9/21/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "GameBoardData.h"

@implementation GameBoardData

- (id)init
{
    self = [super init];
    if (self) {
        [self defineGameBoards];
    }
    return self;
}

- (void)defineGameBoards
{
    NSMutableArray *board1 = [[NSMutableArray alloc] initWithObjects:
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:4],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:1],
                              nil];
    
    NSMutableArray *board2 = [[NSMutableArray alloc] initWithObjects:
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                            
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:0],
                              
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:1],
                              [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:2],
                              nil];
    
    gameBoards = [[NSMutableArray alloc] initWithObjects:board1, board2, nil];
}

- (NSMutableArray *)getGameBoard:(int)boardIndex
{
    return [gameBoards objectAtIndex:boardIndex];
}

/*
- (NSMutableArray *)getGameBoard:(int) boardIndex
{
    return [gameBoards objectAtIndex:boardIndex];
}
 */

@end
