//
//  PuzzleModule.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <stdlib.h>
#import "GameData.h"
#import "Piece.h"
#import "Constants.h"
#import "GameBoardData.h"
#import "AnimationsClass.h"
#import "BattleManager.h"
#include "SaveLoadDataDevice.h"
#include "PointBurst.h"
#include "AudioPlayer.h"

@protocol PuzzleModuleProtocol <NSObject>

- (void)displayEncouragingMessage:(NSString *)message;
- (void)noMoreMovesShufflingWithMessage:(NSString *)message;

@end

@interface PuzzleModule : UIView <PieceProtocol, AnimationsClassProtocol, BattleManagerProtocolPuzzle>
{
    GameBoardData *gameBoardData;
    NSMutableArray *currentGameBoard;
    Piece *firstPiece;
    AnimationsClass *animationClass;
    Constants *constants;
    
    int numPieces;
    int spacing;
    int offsetX;
    int offsetY;
    int animSpacing;
    
    NSMutableArray *grid;
    UIView *gameSprite;
    UIView *blockPiecesView;
    BOOL isDropping;
    BOOL isSwapping;
    BOOL firstPieceSelected;
    BOOL gridCreated;
    BOOL firstMoveMade;
    BOOL madeMove;
    BOOL firstPlay;
    BOOL noMatchesNeedToRedrawScreen;
    int gameScore;
    int pieceIndex;
    int puzzleStartIndex;
    
    int newBoardPieceIndex;
    
    NSTimer *animationTimer;
    NSTimer *completedTimer;
    NSTimer *opponentTurnTimer;
}

@property (weak) id <PuzzleModuleProtocol>delegate;



@end
