//
//  GameBoardData.h
//  robotz
//
//  Created by Jason Elwood on 9/21/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"

@interface GameBoardData : NSObject
{
    NSMutableArray *gameBoards;
    Piece *piece;
}

- (NSMutableArray *) getGameBoard:(int) boardIndex;

@end
