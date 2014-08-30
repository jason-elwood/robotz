//
//  PuzzleModule.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "PuzzleModule.h"

@implementation PuzzleModule

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        noMatchesNeedToRedrawScreen = NO;
        //NSLog(@"Initializing Puzzle Module.");
        firstPlay = YES;
        constants = [[Constants alloc] init];
        BattleManager *bm = [BattleManager sharedManager];
        bm.delegatePuzzle = self;
        numPieces = 7;
        spacing = 52;
        animSpacing = 13; // used to animate the pieces onto the grid
        offsetX = 0;
        offsetY = 0;
        pieceIndex = 0;
        gridCreated = NO;
        firstMoveMade = NO;
        gameBoardData = [[GameBoardData alloc] init];
        SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
        puzzleStartIndex = [sldd getPuzzleStartIndexWithPuzzlePiecesLength:[[gameBoardData getGameBoard:0] count]];
        pieceIndex = puzzleStartIndex;
        animationClass = [[AnimationsClass alloc] init];
        animationClass.delegate = self;
        [self startPuzzleCreation];
    }
    return self;
}

- (void)pieceAnimationFinished
{
    madeMove = YES;
}

// set up grid and start game timer
- (void)startPuzzleCreation
{
    //NSLog(@"startPuzzleCreation");
    
    UIImage *puzzleBGImage = [UIImage imageNamed:@"puzzleModuleBackground.png"];
    UIImageView *puzzleBGImageView = [[UIImageView alloc] initWithImage:puzzleBGImage];
    [self addSubview:puzzleBGImageView];
    
    grid = [[NSMutableArray alloc] init];
    currentGameBoard = [[NSMutableArray alloc] initWithArray:[gameBoardData getGameBoard:0]]; //** NEEDS TO BE DYNAMIC AND SOMEWHAT RANDOM **//
    for (int gridrows = 0; gridrows < 5; gridrows++) {
        [grid addObject:[[NSMutableArray alloc] init]];
    }
    NSDate *setupGridDate = [NSDate dateWithTimeIntervalSinceNow: 1.0];
    NSTimer *gridAnimationTimer = [[NSTimer alloc] initWithFireDate:setupGridDate interval:0.02 target:self selector:@selector(setUpGrid:) userInfo:nil repeats:NO];
    NSRunLoop *setupGridRunner = [NSRunLoop currentRunLoop];
    [setupGridRunner addTimer: gridAnimationTimer forMode: NSDefaultRunLoopMode];
    
    isDropping = NO;
    isSwapping = NO;
    gameScore = 0;
}

/************************************************************************************************************************************************
 The createAnimationTimer timer looks to see if a piece is not at it's proper position on the grid and animates it to that place.
 ************************************************************************************************************************************************/
- (void)createAnimationTimer
{
    [animationTimer invalidate];
    animationTimer = nil;
    // Create a timer that calls movePieces: at 1/60 sec
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(movePieces:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}


/************************************************************************************************************************************************
 The grid is the 2D array that contains the row and column positions of all game pieces.
 The reason we call redrawScreen in stead of just continue when there is a match or no possible match is so that we can 
 handle the event, such as displaying a message to the screen.
 ************************************************************************************************************************************************/
- (void)setUpGrid:(NSTimer *)timer
{
    newBoardPieceIndex = 0;
    [timer invalidate];
    timer = nil;
    //NSLog(@"setUpGrid");
    //create sprite
    gameSprite = [[UIView alloc] initWithFrame:CGRectMake(3, 2, 320, 320)];
    gameSprite.backgroundColor = [UIColor clearColor];
    
    //loop until valid starting grid
    while (true) {
        // add 30 random pieces
        for (int row = 4; row >= 0; row--) {
            for (int col = 0;  col < 6 ; col++) {
                [self addPieceRow:row andCol:col];
            }
        }
        
        // try again if matches are present
        if ([[self lookForMatches] count] != 0) {
            //NSLog(@"Matches. rebuilding grid");
            //continue;
            [self redrawScreen];
        }
        // try again if no possible moves
        if ([self lookForPossibles] == NO) {
            //NSLog(@"No possible matches. rebuilding grid.");
            //continue;
            [self redrawScreen];
        }
        
        break;
    }
    
    [self createAnimationTimer];
    
    [self addSubview:gameSprite];
    gridCreated = YES;
    
    //NSLog(@"adding the gameSprite");
}

// ******************************************************************************************************************
// | ADD THE PIECES TO THE GAMESPRITE AND THE GRID ARRAY
// | Updates:
// +-----------------------------------------------------------------------------------------------------------------
// | Create a Piece object and insert it properly in the grid array using the passed in row and col arguments
// | Initialize the piece properties frame, x, y, col and row
// | Increment pieceIndex
// | Return the piecIndex in case we want to change something, which we do in the addNewPieces method.
// ******************************************************************************************************************
- (Piece *)addPieceRow:(int)row andCol:(int)col
{
    if (pieceIndex > [currentGameBoard count] - 1) { // This happens when we reach the last piece in the currentGameBoard array. So reset to 0.
        //NSLog(@"Reset pieceIndex.");
        pieceIndex = 0;
    }
    
    Piece *newPiece = [[Piece alloc] initWithFrame:CGRectMake(col * spacing + offsetX, row * spacing + offsetY - 312 - (animSpacing * newBoardPieceIndex), 52, 52) pieceType:[[currentGameBoard objectAtIndex:pieceIndex] intValue]];
    
    newPiece.delegate = self;
    
    newPiece.x = col * spacing + offsetX;
    newPiece.y = row * spacing + offsetY - 312 - (animSpacing * newBoardPieceIndex);
    newPiece.col = col;
    newPiece.row = row;
    // *************************************************************************************************
    // ALGORITHM FOR SORTING/SHUFFLING GAME BOARDS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // *************************************************************************************************
    [gameSprite addSubview:newPiece];
    if (gridCreated) {
        [[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:newPiece];
    } else {
        [[grid objectAtIndex:row] insertObject:newPiece atIndex:col];
    }
    pieceIndex++;
    newBoardPieceIndex++; // used to stagger animating the pieces.  Set to zero when a new grid is drawn.
    return newPiece;
}

// ******************************************************************************************************
// | RETURN AN ARRAY OF ALL MATCHES FOUND
// | Updates:
// +-----------------------------------------------------------------------------------------------------
// | Called when board is initialized, upon a swap and on findAndRemoveMatches
// | Upon recieving a match of 3 in a row or greater from getMatchHorizRow or getMatchVertRow we pass
// | the matchList array back to whoever called this method for processing.
// ******************************************************************************************************
- (NSMutableArray *)lookForMatches
{
    NSMutableArray *matchList = [[NSMutableArray alloc] init];
    
    // search for horizontal matches
    for (int row = 0; row < 5; row++) {
        for (int col = 0; col < 6; col++) {
            NSMutableArray *match = [self getMatchHorizRow:row andCol:col];
            if ([match count] > 2) {
                [matchList addObject:match];
                col += [match count] - 1;
            }
        }
    }
    // search for vertical matches
    for (int col = 0; col < 6; col++) {
        for (int row = 0; row < 5; row++) {
            NSMutableArray *match = [self getMatchVertRow:row andCol:col];
            if ([match count] > 2) {
                [matchList addObject:match];
                row += [match count] - 1;
            }
        }
    }
    //NSLog(@"matches : %d", [matchList count]);
    return matchList;
}

// ******************************************************************************************************
// | CHECKS FOR A HORIZONTAL MATCH
// | Updates:
// +-----------------------------------------------------------------------------------------------------
// | Recieves a reference to a piece by means of a row and col argument from the lookForMatches method.
// ******************************************************************************************************
- (NSMutableArray *)getMatchHorizRow:(int)row andCol:(int)col
{
    NSMutableArray *match = [[NSMutableArray alloc] init];
    [match addObject:[[grid objectAtIndex:row] objectAtIndex:col]];
    for (int i = 1; col + i < 6; i++) {
        if (((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).typeIndex == ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col + i]).typeIndex) {
            [match addObject:[[grid objectAtIndex:row] objectAtIndex:col + i]];
        } else {
            return match;
        }
    }
    return match;
}

// ******************************************************************************************************
// | CHECKS FOR A VERTICAL MATCH
// | Updates:
// +-----------------------------------------------------------------------------------------------------
// | Recieves a reference to a piece by means of a row and col argument from the lookForMatches method.
// ******************************************************************************************************
- (NSMutableArray *)getMatchVertRow:(int)row andCol:(int)col
{
    NSMutableArray *match = [[NSMutableArray alloc] init];
    [match addObject:[[grid objectAtIndex:row] objectAtIndex:col]];
    for (int i = 1; row + i < 5; i++) {
        if (((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).typeIndex == ((Piece *)[[grid objectAtIndex:row + i] objectAtIndex:col]).typeIndex) {
            [match addObject:[[grid objectAtIndex:row + i] objectAtIndex:col]];
        } else {
            return match;
        }
    }
    return match;
}

// look to see whether a possible move is on the board
- (BOOL)lookForPossibles
{
    //NSLog(@"lookForPossibles");
    
    for (int col = 0; col < 6; col++) {
        for (int row = 0; row < 5; row++) {
            // horizontal possible, two plus one
            if ([self matchPatternCol:col row:row mustHave:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:0], nil], nil] needOne:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:-2], [NSNumber numberWithInt:0], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:-1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:-1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:0], nil], nil]]) {
                
                return YES;
            }
            
            // horizontal possible, middle
            if ([self matchPatternCol:col row:row mustHave:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:0], nil], nil] needOne:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:-1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil], nil]]) {
                return YES;
            }
            
            // vertical possible, two plus one
            if ([self matchPatternCol:col row:row mustHave:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil], nil] needOne:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:-2], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:-1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:-1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:2], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:3], nil], nil]]) {
                
                return  YES;
            }
            
            // vertical possible, middle
            if ([self matchPatternCol:col row:row mustHave:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:2], nil], nil] needOne:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:1], nil], [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil], nil]]) {
                
                return YES;
            }
        }
    }
    
    // no possible moves found
    return NO;
}

- (BOOL)matchPatternCol:(int)col row:(int)row mustHave:(NSMutableArray *)mustHave needOne:(NSMutableArray *)needOne
{
    int thisType = ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).typeIndex;
    
    // make sure this has all must-haves
    for (int i = 0; i < [mustHave count]; i++) {
        if (![self matchTypeCol:col + [[[mustHave objectAtIndex:i] objectAtIndex:0] intValue] row:row + [[[mustHave objectAtIndex:i] objectAtIndex:1] intValue] type:thisType]) {
            
            return NO;
        }
        
    }
    
    // make sure it has at least one need-ones
    for (int i = 0; i < [needOne count]; i++) {
        if ([self matchTypeCol:col + [[[needOne objectAtIndex:i] objectAtIndex:0] intValue] row:row + [[[needOne objectAtIndex:i] objectAtIndex:1] intValue] type:thisType]) {
            
            return YES;
            
        }
    }
    
    return  NO;
}

- (BOOL)matchTypeCol:(int)col row:(int)row type:(int)type
{
    // make sure col and row aren't beyond the limit
    if (col < 0 || col > 5 || row < 0 || row > 4) {
        return NO;
    }
    return ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).typeIndex == type;
}

- (void)selectedPiece:(id)piece
{
    // first one selected
    if (firstPiece == NULL) {
        [(Piece *)piece toggleSelected:YES];
        firstPiece = (Piece *)piece;
        firstPieceSelected = YES;
    } else if (firstPiece == piece) {
        [(Piece *)piece toggleSelected:NO];
        firstPiece = NULL;
        firstPieceSelected = NO;
    }
    // clicked second piece
    else {
        [firstPiece toggleSelected:NO];
        
        //same row, one column over
        if (firstPiece.row == ((Piece *)piece).row) {
            if (abs(firstPiece.col - ((Piece *)piece).col) == 1) {
                [self makeSwap:firstPiece with:(Piece *)piece];
                firstPiece = NULL;
            }
            // same column, one row over
        } else if (firstPiece.col == ((Piece *)piece).col) {
            if (abs(firstPiece.row - ((Piece *)piece).row) == 1) {
                [self makeSwap:firstPiece with:(Piece *)piece];
                firstPiece = NULL;
            }
        }
        // bad move, reassign first piece
        else {
            firstPiece = (Piece *)piece;
            [firstPiece toggleSelected:YES];
        }
    }
}

//#warning These 2 functions is where we need to implement the initial swap and use a timer to reswap if there is no match.
// ******************************************************************************************************
// | HANDLES SENDING THE PIECES TO SWAPPIECES AND THEN LOOKING FOR A MATCH
// | Updates:
// +-----------------------------------------------------------------------------------------------------
// | Called by selectedPiece when 2 pieces are selected that reside next to each other.
// | 1. Passes the pieces to swapPieces to be swapped.
// | 2. Checks swapPieces passing in the newly swapped pieces for processing to see if there is a match
// |    of 3 or more.
// | 3. If no match, we swap the pieces back using swapPieces again.  Other wise set isSwapping to YES.
// ******************************************************************************************************
- (void)makeSwap:(Piece *)piece1 with:(Piece *)piece2
{
    firstPlay = NO;
    [self swapPieces:piece1 with:piece2];
    
    // check to see if move was fruitful
    if ([[self lookForMatches] count] == 0) {
        [self swapPieces:piece1 with:piece2];
        for (int i = 0; i < [grid count]; i++) {
            for (int j = 0; j < [[grid objectAtIndex:i] count]; j++) {
                ((Piece *)[[grid objectAtIndex:i] objectAtIndex:j]).swapping = NO;
            }
        }
    } else {
        isSwapping = YES;
    }
}

// ******************************************************************************************************
// | SWAPS 2 PIECES IN THE GRID ARRAY AND UPDATES THEIR ROW AND COL PROPERTIES
// | Updates:
// +-----------------------------------------------------------------------------------------------------
// | Recieves TWO PIECES AND SWAPS THEM IN THE GRID ARRAY AFTER REVERSING THEIR PROPERTIES.
// ******************************************************************************************************
- (void)swapPieces:(Piece *)piece1 with:(Piece *)piece2
{
    // swap row and column values
    int tempCol = piece1.col;
    int tempRow = piece1.row;
    piece1.col = piece2.col;
    piece1.row = piece2.row;
    piece2.col = tempCol;
    piece2.row = tempRow;
    
    // swap grid positions
    [[grid objectAtIndex:piece2.row] replaceObjectAtIndex:piece2.col withObject:piece2];
    [[grid objectAtIndex:piece1.row] replaceObjectAtIndex:piece1.col withObject:piece1];
}

// ***************************************************************************************************************
// HANDLE THE PIECE SWAP ANIMATIONS!!!!!!!!!!!!!!!!!!!!!!!!!
// ***************************************************************************************************************
- (void)movePieces:(NSTimer *)timer
{
    madeMove = NO;
    for (int row = 0; row < 5; row++) {
        for (int col = 0; col < 6; col++) {
            if ([[grid objectAtIndex:row] objectAtIndex:col] != [NSNull null]) {
                
                // needs to move down
                if (((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y < ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).row * spacing + offsetY) {
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).frame = CGRectMake(((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x, ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y + 13, 52, 52);
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y += 13;
                    madeMove = YES;
                    
                    if (((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y == ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).row * spacing + offsetY) {
                        [[AudioPlayer sharedManager] playPieceTapSoundAtVolume:1.0];
                    }
                    
                    
                // needs to move up
                }
                else if (((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y > ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).row * spacing + offsetY) {
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).frame = CGRectMake(((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x, ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y - 13, 52, 52);
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y -= 13;
                    madeMove = YES;
                
                // needs to move right
                }
                else if (((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x < ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).col * spacing + offsetX) {
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).frame = CGRectMake(((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x + 13, ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y, 52, 52);
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x += 13;
                    madeMove = YES;
                    
                // needs to move left
                }
                else if (((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x > ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).col * spacing + offsetX) {
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).frame = CGRectMake(((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x - 13, ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).y, 52, 52);
                    ((Piece *)[[grid objectAtIndex:row] objectAtIndex:col]).x -= 13;
                    madeMove = YES;
                }
            }
        }
    }
    
    // if all dropping is done
    if (isDropping && !madeMove) {
        isDropping = NO;
        [self findAndRemoveMatches];
    } else if (isSwapping && !madeMove) {
        isSwapping = NO;
        [self findAndRemoveMatches];
    }
}

- (void)findAndRemoveMatches
{
    // get list of matches
    if (!firstMoveMade) {
        NSMutableArray *matches = [self lookForMatches];
        // Create a timer that calls movePieces: at 1/60 sec
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
        NSTimer *fadeOutMatchesTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(fadeOutMatches:) userInfo:matches repeats:YES];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer: fadeOutMatchesTimer forMode: NSDefaultRunLoopMode];
        
        // no matches found, redraw screen
        if ([matches count] == 0) {
            if (![self lookForPossibles]) {
                //NSLog(@"no matches found");
                noMatchesNeedToRedrawScreen = YES;
                //[self redrawScreen];
            }
        }
    }
}

- (void)fadeOutMatches:(NSTimer *)timer
{
    NSMutableArray *matches = [timer userInfo];
    for (int i = 0; i < [matches count]; i++) {
        for (int j = 0; j < [[matches objectAtIndex:i] count]; j++) {
            ((Piece *)[[matches objectAtIndex:i] objectAtIndex:j]).alpha -= 0.1;
            if (((Piece *)[[matches objectAtIndex:i] objectAtIndex:j]).alpha < 0.1) {
                [timer invalidate];
                timer = nil;
                [self removeMatches:matches];
                return;
            }
        }
    }
}

- (void)removeMatches:(NSMutableArray *)matchesArray
{
    newBoardPieceIndex = 0;
    NSMutableArray *matches = matchesArray;
    
    if ([matches count] == 2) {
        [delegate displayEncouragingMessage:constants.MESSAGENICE];
    } else if ([matches count] == 2) {
        [delegate displayEncouragingMessage:constants.MESSAGEAWESOME];
    }
    
    for (int i = 0; i < [matches count]; i++) {
        if ([[matches objectAtIndex:i] count]  == 4) {
            [delegate displayEncouragingMessage:constants.MESSAGEGREAT];
        } else if ([[matches objectAtIndex:i] count] == 5) {
            [delegate displayEncouragingMessage:constants.MESSAGEAWESOME];
        }
    }
    
    /*
     Concat the matches array objects so they that all pieces can be 
     compared to each other and the duplicates removed.
     */
    NSArray *newArray = [[NSArray alloc] init];
    newArray = [matches objectAtIndex:0];
    for (int i = 1; i < [matches count]; i++) {
         newArray = [newArray arrayByAddingObjectsFromArray:[matches objectAtIndex:i]];
    }
    NSMutableArray *newMutableArray = [[NSMutableArray alloc] initWithArray:newArray];
    
    //NSLog(@"newArray : %@", newMutableArray);
    
    for(int i = 0; i < [newMutableArray count]; i++){
        for(int j = i + 1; j < [newMutableArray count]; j++){
            if([newMutableArray objectAtIndex:i] == [newMutableArray objectAtIndex:j]) {
                [newMutableArray removeObjectAtIndex:j];
                //NSLog(@"duplicate piece removed.");
            }
        }
    }
    
    [matches removeAllObjects];
    [matches addObject:newMutableArray];
    
    for (int i = 0; i < [matches count]; i++) {
        float numPoints = ([[matches objectAtIndex:i] count] - 1) * 100;
        [self playersMove:matches];
        BattleManager *bm = [BattleManager sharedManager];
        [bm incrementScore:numPoints];
        // POINT BURST ANIMATION --------------------------------------------------
        Piece *tempPiece = [[matches objectAtIndex:i] objectAtIndex:1];
        PointBurst *pb = [[PointBurst alloc] init];
        [pb createPointBurstWithPoints:numPoints withColor:[UIColor greenColor]];
        pb.frame = CGRectMake(tempPiece.frame.origin.x + 5, tempPiece.frame.origin.y, 50, 30);
        [self addSubview:pb];
        [animationClass animatePointBurst:pb];
        // POINT BURST ANIMATION --------------------------------------------------
        for (int j = 0; j < [[matches objectAtIndex:i] count]; j++) {
            [self addScore:numPoints];
            Piece *tempPiece = (Piece *)[[matches objectAtIndex:i] objectAtIndex:j];
            [tempPiece removeFromSuperview];
            [[grid objectAtIndex:tempPiece.row] replaceObjectAtIndex:tempPiece.col withObject:[NSNull null]];
            [self affectAbove:[[matches objectAtIndex:i] objectAtIndex:j]];
        }
    }
    // add any new piece to top of board
    [self addNewPieces];
    
    // no matches found, maybe the game is over?
    if ([matches count] == 0) {
        if (![self lookForPossibles]) {
            //NSLog(@"no matches found");
            [self redrawScreen];
        }
    }
    
    [completedTimer invalidate];
    completedTimer = nil;
    
    [opponentTurnTimer invalidate];
    opponentTurnTimer = nil;
    
    OpponentData *od = [OpponentData sharedManager];
    if (od.hitPoints <= 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 2.0];
        completedTimer = [[NSTimer alloc] initWithFireDate:date interval:0.0 target:self selector:@selector(animationsEnded:) userInfo:nil repeats:NO];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer: completedTimer forMode: NSDefaultRunLoopMode];
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 2.0];
        opponentTurnTimer = [[NSTimer alloc] initWithFireDate:date interval:0.0 target:self selector:@selector(opponentsTurn:) userInfo:nil repeats:NO];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer: opponentTurnTimer forMode: NSDefaultRunLoopMode];
    }
    //[self lockPlayerControls];
}

- (NSArray *)removeDuplicates:(NSMutableArray *)matches
{
    return [[NSArray alloc] init];
}

- (void)animationsEnded:(NSTimer *)timer
{
    //NSLog(@"animationsEnded");
    [completedTimer invalidate];
    completedTimer = nil;
    BattleManager *bm = [BattleManager sharedManager];
    [bm animationsEnded];
}

- (void)opponentsTurn:(NSTimer *)timer
{
    OpponentData *od = [OpponentData sharedManager];
    if (od.hitPoints <= 0) {
        [self animationsEnded:[[NSTimer alloc] init]];
        return;
    }
    BattleManager *bm = [BattleManager sharedManager];
    [bm opponentMakesMoveWithPieceType:0 numberOfPieces:0];
}

// ******************************************************************************************************************
// | TELL ALL PIECES ABOVE THIS ONE TO MOVE DOWN.
// | Updates: increments row property of piece by 1. Updates grid array so pieces move down and null objects move up.
// +-----------------------------------------------------------------------------------------------------------------
// | affectAbove is called when we have a match.  A piece from the matches array is passed in 1 at a time.
// | We set the iterator to piece.row - 1 so we can evaluate the pieces in the column above the passed in piece.
// | As long as the row is greater than 0 we continue to evaluate pieces.
// | After checking whether the object is not Null (at which point we do nothing)
// | we increment the row preperty of Piece by 1.
// | Then in the grid array, we replace the passed in piece with the piece above it.
// | Then we set the vacated spot to a null object.
// ******************************************************************************************************************
- (void) affectAbove:(Piece *)piece
{
    for (int row = piece.row - 1; row >= 0; row--) {
        if ([[grid objectAtIndex:row] objectAtIndex:piece.col] != [NSNull null]) {
            ((Piece *)[[grid objectAtIndex:row] objectAtIndex:piece.col]).row++;
            [[grid objectAtIndex:row + 1] replaceObjectAtIndex:piece.col withObject:[[grid objectAtIndex:row] objectAtIndex:piece.col]];
            [[grid objectAtIndex:row] replaceObjectAtIndex:piece.col withObject:[NSNull null]];
        }
    }
    firstMoveMade = NO;
}

// ******************************************************************************************************************
// | IF THERE ARE MISSING PIECES IN A COLUMN, ADD ONE TO DROP
// | Updates: Creates newPiece instance, sets its y property and frame to a negative y value above the gameSprite.
// +-----------------------------------------------------------------------------------------------------------------
// | addNewPieces inspects the entire grid looking for null objects.
// | When one is found it creates a new Piece by sending the row and column of the void object to addPieceRow:andCol:
// | The y property of the new piece is set to negative number so the piece can appear to drop.
// | The frame of the new piece is set to this same negative number.
// | Set isDropping to YES
// ******************************************************************************************************************
- (void)addNewPieces
{
    for (int col = 0; col < 6; col++) {
        int missingPieces = 0;
        for (int row = 4; row >= 0; row--) {
            if ([[grid objectAtIndex:row] objectAtIndex:col] == [NSNull null]) {
                Piece *newPiece = [self addPieceRow:row andCol:col];
                newPiece.y = offsetY - spacing- spacing * missingPieces++;
                newPiece.frame = CGRectMake(col * 52, offsetY - spacing- spacing * missingPieces++, 52, 52);
                isDropping = YES;
                [self incrementPiecesCleared];
            }
        }
    }
}

- (void)incrementPiecesCleared
{
    BattleManager *bm = [BattleManager sharedManager];
    [bm incrementGamePiecesCleared:1];
}

- (void)lockPlayerControls
{
    //NSLog(@"lockPlayerControls");
    if (!blockPiecesView) {
        blockPiecesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gameSprite.frame.size.width, gameSprite.frame.size.height)];
        blockPiecesView.backgroundColor = [UIColor clearColor];
        [self addSubview:blockPiecesView];
        [animationClass animateAlphaImageViewsLayer:gameSprite.layer from:1.0 to:0.3 duration:0.5 repeat:0];
        gameSprite.alpha = 0.3;
    }
}

- (void)unlockPlayerControls
{
    
    if (noMatchesNeedToRedrawScreen) {
        [self redrawScreen];
        noMatchesNeedToRedrawScreen = NO;
    }
    //NSLog(@"unlockPlayerControls");
    [blockPiecesView removeFromSuperview];
    blockPiecesView = nil;
    [animationClass animateAlphaImageViewsLayer:gameSprite.layer from:0.3 to:1.0 duration:0.5 repeat:0];
    gameSprite.alpha = 1.0;
    for (int i = 0; i < [grid count]; i++) {
        for (int j = 0; j < [[grid objectAtIndex:i] count]; j++) {
            ((Piece *)[[grid objectAtIndex:i] objectAtIndex:j]).swapping = NO;
        }
    }
}

- (void)addScore:(int)score
{
    
}

// ******************************************************************************************************************
// | NO MATCHES.  REDRAW THE PIECES AND GRID
// | Updates: Clears the grid and adds all new pieces
// +-----------------------------------------------------------------------------------------------------------------
// |
// ******************************************************************************************************************
- (void)redrawScreen
{
    [animationTimer invalidate];
    animationTimer = nil;
    
    if (!firstPlay) {
        [delegate noMoreMovesShufflingWithMessage:constants.MESSAGENOMOREMATCHES];
    }
    
    for (int row = 0; row < [grid count]; row++) {
        for (int col = 0; col < [[grid objectAtIndex:row] count]; col++) {
            [(Piece *)[[grid objectAtIndex:row] objectAtIndex:col] removeFromSuperview];
        }
    }
    //[grid removeAllObjects];
    
    NSDate *setupGridDate = [NSDate dateWithTimeIntervalSinceNow: 1.0];
    NSTimer *gridAnimationTimer = [[NSTimer alloc] initWithFireDate:setupGridDate interval:0.02 target:self selector:@selector(setUpGrid:) userInfo:nil repeats:NO];
    NSRunLoop *setupGridRunner = [NSRunLoop currentRunLoop];
    [setupGridRunner addTimer: gridAnimationTimer forMode: NSDefaultRunLoopMode];
}

- (void)playersMove:(NSMutableArray *)matches
{
    //NSLog(@"playersMove matches: %@", matches);
    BattleManager *bm = [BattleManager sharedManager];
    [bm playerMakesMoveWithPieceType:((Piece *)[[matches objectAtIndex:0] objectAtIndex:0]).typeIndex numberOfPieces:[[matches objectAtIndex:0] count]];
}

- (void)opponentAttack:(int)attackType
{
    //NSLog(@"opponentAttack!!!!!!!!!!!!! attackType : %d", attackType);
    BattleManager *bm = [BattleManager sharedManager];
    [bm opponentAnimationsEnded];
}

- (void)swapPieceLeft:(id)piece
{
    Piece *tempPiece = piece;
    if (tempPiece.col != 0) {
        [self makeSwap:[[grid objectAtIndex:tempPiece.row] objectAtIndex:tempPiece.col] with:[[grid objectAtIndex:tempPiece.row] objectAtIndex:tempPiece.col - 1]];
        for (int i = 0; i < [grid count]; i++) {
            for (int j = 0; j < [[grid objectAtIndex:i] count]; j++) {
                ((Piece *)[[grid objectAtIndex:i] objectAtIndex:j]).swapping = YES;
            }
        }
    }
    //NSLog(@"tempPiec col : %d and row : %d and swapping = %d", tempPiece.col, tempPiece.row, tempPiece.swapping);
}

- (void)swapPieceRight:(id)piece
{
    Piece *tempPiece = piece;
    if (tempPiece.col != 5) {
        [self makeSwap:[[grid objectAtIndex:tempPiece.row] objectAtIndex:tempPiece.col] with:[[grid objectAtIndex:tempPiece.row] objectAtIndex:tempPiece.col + 1]];
        for (int i = 0; i < [grid count]; i++) {
            for (int j = 0; j < [[grid objectAtIndex:i] count]; j++) {
                ((Piece *)[[grid objectAtIndex:i] objectAtIndex:j]).swapping = YES;
            }
        }
    }
    //NSLog(@"tempPiec col : %d and row : %d and swapping = %d", tempPiece.col, tempPiece.row, tempPiece.swapping);
}

- (void)swapPieceUp:(id)piece
{
    Piece *tempPiece = piece;
    if (tempPiece.row != 0) {
        [self makeSwap:[[grid objectAtIndex:tempPiece.row] objectAtIndex:tempPiece.col] with:[[grid objectAtIndex:tempPiece.row - 1] objectAtIndex:tempPiece.col]];
        for (int i = 0; i < [grid count]; i++) {
            for (int j = 0; j < [[grid objectAtIndex:i] count]; j++) {
                ((Piece *)[[grid objectAtIndex:i] objectAtIndex:j]).swapping = YES;
            }
        }
    }
    //NSLog(@"tempPiec col : %d and row : %d and swapping = %d", tempPiece.col, tempPiece.row, tempPiece.swapping);
}

- (void)swapPieceDown:(id)piece
{
    Piece *tempPiece = piece;
    if (tempPiece.row != 5) {
        [self makeSwap:[[grid objectAtIndex:tempPiece.row] objectAtIndex:tempPiece.col] with:[[grid objectAtIndex:tempPiece.row + 1] objectAtIndex:tempPiece.col]];
        for (int i = 0; i < [grid count]; i++) {
            for (int j = 0; j < [[grid objectAtIndex:i] count]; j++) {
                ((Piece *)[[grid objectAtIndex:i] objectAtIndex:j]).swapping = YES;
            }
        }
    }
    //NSLog(@"tempPiec col : %d and row : %d and swapping = %d", tempPiece.col, tempPiece.row, tempPiece.swapping);
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
