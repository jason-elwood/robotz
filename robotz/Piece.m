//
//  Piece.m
//  robotz
//
//  Created by Jason Elwood on 9/20/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "Piece.h"

@implementation Piece

@synthesize gamePieceImages, typeIndex, delegate, col, row, x, y, swapping;

- (id)initWithFrame:(CGRect)frame pieceType:(int)index
{
    self = [super initWithFrame:frame];
    if (self) {
        swapping = NO;
        // Initialization code
        gamePieceImages = [[NSMutableArray alloc] initWithObjects:@"gamePiece1.png", @"gamePiece2.png", @"gamePiece3.png", @"gamePiece4.png", @"gamePiece5.png", @"gamePiece6.png", @"gamePiece7.png", nil];
        
        typeIndex = index;
        
        UIImage *gamePieceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[gamePieceImages objectAtIndex:index]]];
        UIImageView *gamePieceImageView = [[UIImageView alloc] initWithImage:gamePieceImage];
        [self addSubview:gamePieceImageView];
        
        UIImage *selectedGamePieceFrameImage = [UIImage imageNamed:@"selectedPieceFrame.png"];
        selectedGamePieceFrame = [[UIImageView alloc] initWithImage:selectedGamePieceFrameImage];
        isSelected = NO;
    
    }
    return self;
}

- (void)createGamePiece:(int)imageIndex
{
    UIImage *gamePieceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[gamePieceImages objectAtIndex:imageIndex]]];
    UIImageView *gamePieceImageView = [[UIImageView alloc] initWithImage:gamePieceImage];
    [self addSubview:gamePieceImageView];
}

- (void)toggleSelected:(BOOL)selected
{
    if (selected) {
        //[self addSubview:selectedGamePieceFrame];
        isSelected = YES;
    } else {
        //[selectedGamePieceFrame removeFromSuperview];
        isSelected = NO;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:self] anyObject];
    
    CGPoint location = [touch locationInView:touch.view];
    
    NSLog(@"touch location x : %f and y : %f", location.x, location.y);
    
    [self toggleSelected:YES];
    
    //    if(CGRectContainsPoint(myObject.frame, location) && lastButton != myObject))
    //    {
    //        [self oneFunction];
    //        [oneButton setHighlighted:YES];
    //    }
    //    if(CGRectContainsPoint(twoButton.frame, location))
    //    {
    //        [self twoFunction];
    //        [twoButton setHighlighted:YES];
    //    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (swapping) {
        return;
    }
    UITouch *touch = [[event touchesForView:self] anyObject];
    
    CGPoint location = [touch locationInView:touch.view];
    
    if (location.x < -20) {
        NSLog(@"swap with piece on the left.");
        [delegate swapPieceLeft:self];
    } else if (location.x > self.frame.size.width + 20) {
        NSLog(@"swap with piece on the right.");
        [delegate swapPieceRight:self];
    } else if (location.y < -20) {
        NSLog(@"swap with piece above this one");
        [delegate swapPieceUp:self];
    } else if (location.y > self.frame.size.height + 20) {
        NSLog(@"swap with piece below this one");
        [delegate swapPieceDown:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self toggleSelected:NO];
    swapping = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
