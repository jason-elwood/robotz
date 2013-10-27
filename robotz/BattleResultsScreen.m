//
//  BattleResultsScreen.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "BattleResultsScreen.h"

@implementation BattleResultsScreen

@synthesize delegate, boostUnlocked;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        playerLeveledUp = NO;
        boostUnlocked = NO;
        deviceTypes = [[DeviceTypes alloc] init];
        constants = [[Constants alloc] init];
        scoreIndex = 0;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIImage *bgImage = [UIImage imageNamed:@"battleResults.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [self addSubview:bgImageView];
    
    levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 48, 20, 20)];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    [levelLabel setTextColor:[UIColor whiteColor]];
    levelLabel.text = @"1";
    [self addSubview:levelLabel];
    
    UIImage *expBarImage = [UIImage imageNamed:@"expBar.png"];
    expBar = [[UIImageView alloc] initWithImage:expBarImage];
    expBarMaxWidth = expBarImage.size.width;
    expBar.frame = CGRectMake(68.5, 53.5, 100, expBarImage.size.height);
    [self addSubview:expBar];
    
    totalCoinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 78, 185, 20)];
    totalCoinsLabel.textAlignment = NSTextAlignmentRight;
    [totalCoinsLabel setTextColor:[UIColor whiteColor]];
    totalCoinsLabel.text = @"";
    [self addSubview:totalCoinsLabel];
    
    gamePiecesClearedLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 245, 185, 20)];
    gamePiecesClearedLabel.textAlignment = NSTextAlignmentLeft;
    [gamePiecesClearedLabel setTextColor:[UIColor orangeColor]];
    gamePiecesClearedLabel.text = @"";
    [self addSubview:gamePiecesClearedLabel];
    
    boostsUsedLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 262, 185, 20)];
    boostsUsedLabel.textAlignment = NSTextAlignmentLeft;
    [boostsUsedLabel setTextColor:[UIColor orangeColor]];
    boostsUsedLabel.text = @"";
    [self addSubview:boostsUsedLabel];
    
    expEarnedLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 279, 185, 20)];
    expEarnedLabel.textAlignment = NSTextAlignmentLeft;
    [expEarnedLabel setTextColor:[UIColor orangeColor]];
    expEarnedLabel.text = @"";
    [self addSubview:expEarnedLabel];
    
    coinsEarnedLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 296, 185, 20)];
    coinsEarnedLabel.textAlignment = NSTextAlignmentLeft;
    [coinsEarnedLabel setTextColor:[UIColor orangeColor]];
    coinsEarnedLabel.text = @"";
    [self addSubview:coinsEarnedLabel];
    
    finalScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 345, deviceTypes.deviceWidth, 50)];
    finalScoreLabel.textAlignment = NSTextAlignmentCenter;
    [finalScoreLabel setTextColor:[UIColor whiteColor]];
    finalScoreLabel.font = [UIFont fontWithName:@"Helvetica" size:35.0];
    finalScoreLabel.text = @"";
    [self addSubview:finalScoreLabel];
    
    UIImage *goldStarLeftImage = [UIImage imageNamed:@"goldStarLeft.png"];
    UIImage *goldStarMiddleImage = [UIImage imageNamed:@"goldStarMiddle.png"];
    UIImage *goldStarRightImage = [UIImage imageNamed:@"goldStarRight.png"];
    goldStarleft = [[UIImageView alloc] initWithImage:goldStarLeftImage];
    goldStarMiddle = [[UIImageView alloc] initWithImage:goldStarMiddleImage];
    goldStarRight = [[UIImageView alloc] initWithImage:goldStarRightImage];
    
    goldStarleft.frame = CGRectMake(52.5, 154, goldStarLeftImage.size.width, goldStarLeftImage.size.height);
    goldStarleft.alpha = 0.0;
    [self addSubview:goldStarleft];
    goldStarMiddle.frame = CGRectMake(128, 127.5, goldStarMiddleImage.size.width, goldStarMiddleImage.size.height);
    goldStarMiddle.alpha = 0.0;
    [self addSubview:goldStarMiddle];
    goldStarRight.frame = CGRectMake(205, 154, goldStarRightImage.size.width, goldStarRightImage.size.height);
    goldStarRight.alpha = 0.0;
    [self addSubview:goldStarRight];
    
    [self loadData];
    
    UIImage *continueButtonImage = [UIImage imageNamed:@"continueButtonLarge.png"];
    continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton setImage:continueButtonImage forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(closeBattleResults:) forControlEvents:UIControlEventTouchUpInside];
    continueButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - continueButtonImage.size.width / 2 + 1, 393, continueButtonImage.size.width, continueButtonImage.size.height);
    continueButton.alpha = 0.5;
    continueButton.enabled = NO;
    [self addSubview:continueButton];
    
    UIImage *levelUpImage = [UIImage imageNamed:@"levelUpText.png"];
    levelUpTextView = [[UIImageView alloc] initWithImage:levelUpImage];
    levelUpTextView.frame = CGRectMake(deviceTypes.deviceWidth / 2 - levelUpImage.size.width / 2, 200, levelUpImage.size.width, levelUpImage.size.height);
    levelUpTextView.alpha = 0.0;
    [self addSubview:levelUpTextView];
}

- (void)loadData
{
    BattleManager *bm = [BattleManager sharedManager];
    [self setCoinsAndExpEarned];
    
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    NSMutableDictionary *savedData = [sldd getCharData];
    level = [[savedData objectForKey:constants.PLAYERSLEVEL] intValue];
    [self updateLevelLabel];
    currentExperience = [[savedData objectForKey:constants.CURRENTEXPERIENCE] intValue];
    expToLevel = [[savedData objectForKey:constants.EXPERIENCETOLEVEL] intValue];
    expBar.frame = CGRectMake(expBar.frame.origin.x, expBar.frame.origin.y, expBarMaxWidth * currentExperience / expToLevel, expBar.frame.size.height);
    score = [bm getScore];
    expBarFrom = expBar.frame.size.width;
    expBarIndex = expBarFrom;
    expBarTo = expBarFrom + (expBarMaxWidth * (expEarned / expToLevel));
    [self setCoinsAndExpEarned];
    [self beginAnimations];
    
    //[self saveBattleData];
}

- (void)setCoinsAndExpEarned
{
    BattleManager *bm = [BattleManager sharedManager];
    if (bm.playerWon) {
        expEarned = [bm getExpAwarded];
        coinsEarned = [bm getCoinsAwarded];
    } else {
        expEarned = [bm getExpAwarded] / 5;
        coinsEarned = [bm getCoinsAwarded] / 5;
    }
}

- (void)saveBattleData
{
    if (remainingXp == 0) {
        remainingXp = currentExperience + expEarned;
    }
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    [sldd setCurrentExperience:remainingXp];
    [sldd setPlayersCoins:[[[sldd getCharData] objectForKey:constants.TOTALCOINS] intValue] + coinsEarned];
    NSLog(@"saveBattleData - currentExperience = %f, + expEarned = %f = %f", currentExperience, expEarned, currentExperience + expEarned);
}

- (void)updateLevelLabel
{
    levelLabel.text = [NSString stringWithFormat:@"%d", level];
}

- (void)beginAnimations
{
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow: 1.0];
    piecesClearTimer = [[NSTimer alloc] initWithFireDate:date1 interval:0.02 target:self selector:@selector(animateGamePiecesCleared:) userInfo:nil repeats:YES];
    NSRunLoop *runner1 = [NSRunLoop currentRunLoop];
    [runner1 addTimer: piecesClearTimer forMode: NSDefaultRunLoopMode];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow: 1.2];
    boostsUsedTimer = [[NSTimer alloc] initWithFireDate:date2 interval:0.02 target:self selector:@selector(animateBoostsUsed:) userInfo:nil repeats:YES];
    NSRunLoop *runner2 = [NSRunLoop currentRunLoop];
    [runner2 addTimer: boostsUsedTimer forMode: NSDefaultRunLoopMode];
    
    NSDate *date3 = [NSDate dateWithTimeIntervalSinceNow: 1.6];
    experienceTimer = [[NSTimer alloc] initWithFireDate:date3 interval:0.02 target:self selector:@selector(animateExperience:) userInfo:nil repeats:YES];
    NSRunLoop *runner3 = [NSRunLoop currentRunLoop];
    [runner3 addTimer: experienceTimer forMode: NSDefaultRunLoopMode];
    
    NSDate *date4 = [NSDate dateWithTimeIntervalSinceNow: 1.8];
    coinsEarnedTimer = [[NSTimer alloc] initWithFireDate:date4 interval:0.02 target:self selector:@selector(animateCoinsEarned:) userInfo:nil repeats:YES];
    NSRunLoop *runner4 = [NSRunLoop currentRunLoop];
    [runner4 addTimer: coinsEarnedTimer forMode: NSDefaultRunLoopMode];
    
    NSDate *date5 = [NSDate dateWithTimeIntervalSinceNow: 2.0];
    finalScoreTimer = [[NSTimer alloc] initWithFireDate:date5 interval:0.02 target:self selector:@selector(animateScore:) userInfo:nil repeats:YES];
    NSRunLoop *runner5 = [NSRunLoop currentRunLoop];
    [runner5 addTimer: finalScoreTimer forMode: NSDefaultRunLoopMode];
    
    NSDate *date6 = [NSDate dateWithTimeIntervalSinceNow: 2.2];
    expBarTimer = [[NSTimer alloc] initWithFireDate:date6 interval:0.02 target:self selector:@selector(animateExperienceBar:) userInfo:nil repeats:YES];
    NSRunLoop *runner6 = [NSRunLoop currentRunLoop];
    [runner6 addTimer: expBarTimer forMode: NSDefaultRunLoopMode];
    
    NSDate *date7 = [NSDate dateWithTimeIntervalSinceNow: 2.4];
    totalCoinsTimer = [[NSTimer alloc] initWithFireDate:date7 interval:0.02 target:self selector:@selector(animateTotalCoins:) userInfo:nil repeats:YES];
    NSRunLoop *runner7 = [NSRunLoop currentRunLoop];
    [runner7 addTimer: totalCoinsTimer forMode: NSDefaultRunLoopMode];
    
    NSDate *date8 = [NSDate dateWithTimeIntervalSinceNow: 2.6];
    animateStarsTimer = [[NSTimer alloc] initWithFireDate:date8 interval:0.02 target:self selector:@selector(animateStars:) userInfo:nil repeats:YES];
    NSRunLoop *runner8 = [NSRunLoop currentRunLoop];
    [runner8 addTimer: animateStarsTimer forMode: NSDefaultRunLoopMode];
    
}

- (void)animateLevelUp:(NSTimer *)timer
{
    NSLog(@"playerLeveledUp : %d", playerLeveledUp);
    if (playerLeveledUp) {
        if (levelUpTextView.alpha < 1.0 && levelUpTextView.frame.origin.y > 100) {
            levelUpTextView.alpha += 0.05;
        }
        if (levelUpTextView.frame.origin.y > 50) {
            levelUpTextView.frame = CGRectMake(levelUpTextView.frame.origin.x, levelUpTextView.frame.origin.y - 1, levelUpTextView.frame.size.width, levelUpTextView.frame.size.height);
        } else {
            [timer invalidate];
            timer = nil;
            [levelUpTextView removeFromSuperview];
            levelUpTextView = nil;
        }
        if (levelUpTextView.alpha > 0.0 && levelUpTextView.frame.origin.y < 100) {
            levelUpTextView.alpha -= 0.05;
        }
    } else {
        [timer invalidate];
        timer = nil;
    }
}

- (void)animateStars:(NSTimer *)timer
{
    //NSLog(@"animateStars");
    int starsEarned = [[BattleManager sharedManager] getNumberStarsEarned];
    if (starsEarned > 0) {
        goldStarleft.alpha += 0.05;
        if (goldStarleft.alpha >= 1.0) {
            goldStarleft.alpha = 1.0;
            [timer invalidate];
            timer = nil;
        }
    }
    if (starsEarned > 1) {
        goldStarMiddle.alpha += 0.05;
        if (goldStarMiddle.alpha >= 1.0) {
            goldStarMiddle.alpha = 1.0;
            [timer invalidate];
            timer = nil;
        }
    }
    if (starsEarned > 2) {
        goldStarRight.alpha += 0.05;
        if (goldStarRight.alpha >= 1.0) {
            goldStarRight.alpha = 1.0;
            [timer invalidate];
            timer = nil;
        }
    }
}

- (void)animateExperienceBar:(NSTimer *)timer
{
    expBar.frame = CGRectMake(expBar.frame.origin.x, expBar.frame.origin.y, expBarIndex, expBar.frame.size.height);
    expBarIndex++;
    if (expBarIndex >= expBarTo) {
        [expBarTimer invalidate];
        expBarTimer = nil;
        [self saveBattleData];
        continueButton.enabled = YES;
        continueButton.alpha = 1.0;
    }
    if (expBar.frame.size.width >= expBarMaxWidth - 1) {
        expBar.frame = CGRectMake(expBar.frame.origin.x, expBar.frame.origin.y, 0, expBar.frame.size.height);
        remainingXp = expEarned - (expToLevel - currentExperience);
        [self levelUpWithRemainingXp:remainingXp];
        
        playerLeveledUp = YES;
        NSDate *date9 = [NSDate dateWithTimeIntervalSinceNow: 0.5];
        animateLevelUpTimer = [[NSTimer alloc] initWithFireDate:date9 interval:0.02 target:self selector:@selector(animateLevelUp:) userInfo:nil repeats:YES];
        NSRunLoop *runner9 = [NSRunLoop currentRunLoop];
        [runner9 addTimer: animateLevelUpTimer forMode: NSDefaultRunLoopMode];
    }
}

- (void)levelUpWithRemainingXp:(float)remainingxp
{
    expBarIndex = 0;
    expBarFrom = 0;
    level++;
    // increase level and get new expToLevel
    [self updateLevelLabel];
    BattleManager *bm = [BattleManager sharedManager];
    [bm levelUpWithLevel:level andRemainingXp:remainingXp];
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    NSMutableDictionary *savedData = [sldd getCharData];
    expToLevel = [[savedData objectForKey:constants.EXPERIENCETOLEVEL] intValue];
    expBarTo = expBarFrom + (expBarMaxWidth * (remainingxp / expToLevel));
    if (level == 2 || level == 3 || level == 4) {
        boostUnlocked = YES;
    }
    
}

- (void)animateScore:(NSTimer *)timer
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:scoreIndex]];
    
    if (scoreIndex > score) {
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:score]];
        finalScoreLabel.text = formatted;
        [finalScoreTimer invalidate];
        finalScoreTimer = nil;
        return;
    }
    
    finalScoreLabel.text = formatted;
    scoreIndex += 100;
    
    formatted = nil;
    formatter = nil;
}

- (void)animateExperience:(NSTimer *)timer
{
    expEarnedLabel.text = [NSString stringWithFormat:@"%d", (int)expEarned];
    [experienceTimer invalidate];
    experienceTimer = nil;
}

- (void)animateCoinsEarned:(NSTimer *)timer
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:coinsEarned]];
    
    [coinsEarnedLabel setText:[NSString stringWithFormat:@"%@", formatted]];
    [coinsEarnedTimer invalidate];
    coinsEarnedTimer = nil;
}

- (void)animateTotalCoins:(NSTimer *)timer
{
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    int newCoinsEarned = [[[sldd getCharData] objectForKey:constants.TOTALCOINS] intValue] + coinsEarned;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:newCoinsEarned]];
    
    totalCoinsLabel.text = [NSString stringWithFormat:@"%@", formatted];
    [totalCoinsTimer invalidate];
    totalCoinsTimer = nil;
}

- (void)animateGamePiecesCleared:(NSTimer *)timer
{
    BattleManager *bm = [BattleManager sharedManager];
    gamePiecesClearedLabel.text = [NSString stringWithFormat:@"%d", [bm getGamePiecesCleared]];
    [piecesClearTimer invalidate];
    piecesClearTimer = nil;
}

- (void)animateBoostsUsed:(NSTimer *)timer
{
    BattleManager *bm = [BattleManager sharedManager];
    boostsUsedLabel.text = [NSString stringWithFormat:@"%d", [bm getBoostsUsed]];
    [boostsUsedTimer invalidate];
    boostsUsedTimer = nil;
}

- (void)closeBattleResults:(id)sender
{
    BattleManager *bm = [BattleManager sharedManager];
    [bm resetScore];
    [bm resetBoostsUsed];
    [bm resetGamePiecesCleared];
    if (boostUnlocked) {
        NSLog(@"boostUnlocked.  calling delegate showBoostUnlockedScreen.");
        [delegate showBoostUnlockedScreen:level];
        return;
    }
    NSLog(@"boost not unlocked.  calling delegate closeBattleResultsScreen.");
    [delegate closeBattleResultsScreen];
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
