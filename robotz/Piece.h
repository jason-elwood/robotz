//
//  Piece.h
//  robotz
//
//  Created by Jason Elwood on 9/20/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@protocol PieceProtocol <NSObject>

- (void)selectedPiece:(id)piece;
- (void)swapPieceLeft:(id)piece;
- (void)swapPieceRight:(id)piece;
- (void)swapPieceUp:(id)piece;
- (void)swapPieceDown:(id)piece;

@end

@interface Piece : UIView
{
    UIImageView *selectedGamePieceFrame;
    BOOL isSelected;
}

@property int col;
@property int row;
@property int y;
@property int x;
@property int typeIndex;
@property BOOL swapping;
@property (nonatomic, retain) NSMutableArray *gamePieceImages;

@property (weak) id delegate;

- (void)createGamePiece:(int)imageIndex;
- (id)initWithFrame:(CGRect)frame pieceType:(int)index;
- (void)toggleSelected:(BOOL)selected;

@end
