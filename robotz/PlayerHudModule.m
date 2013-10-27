//
//  PlayerHudModule.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//
// The PlayerHudModule displays updates to the player and takes feedback from the player for using boosts and calling
// up the menu screen.

#import "PlayerHudModule.h"

@implementation PlayerHudModule

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        numBuffsUsed = 0;
        boostsArray = [[NSMutableArray alloc] init];
        BattleManager *bm = [BattleManager sharedManager];
        boostsData = [[BoostsData alloc] init];
        deviceTypes = [[DeviceTypes alloc] init];
        animations = [[AnimationsClass alloc] init];
        bm.delegateHud = self;
        [self drawHud];
        [bm provideBoostsHudUI];
    }
    return self;
}

- (void)drawHud
{
    boost1Pos = CGPointMake(270, 150);
    boost2Pos = CGPointMake(280, 90);
    boost3Pos = CGPointMake(280, 50);
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, deviceTypes.deviceWidth - 10, 20)]; //fix to be dynamic.
    scoreLabel.textAlignment = NSTextAlignmentLeft;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.text = @"0";
    [self addSubview:scoreLabel];
    
    pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, deviceTypes.deviceWidth - 10, 20)]; //fix to be dynamic
    pointsLabel.textAlignment = NSTextAlignmentRight;
    pointsLabel.textColor = [UIColor whiteColor];
    pointsLabel.text = @"0";
    pointsLabel.alpha = 0.0;
    [self addSubview:pointsLabel];
    
    UIImage *playerHpBarImage = [UIImage imageNamed:@"playerHpBar.png"];
    playerHpBar = [[UIImageView alloc] initWithImage:playerHpBarImage];
    playerHpBar.frame = CGRectMake(deviceTypes.deviceWidth / 2 - playerHpBarImage.size.width / 2, 208, playerHpBarImage.size.width, playerHpBarImage.size.height);
    [self addSubview:playerHpBar];
    
    playersCurrentMaxHealthLabel = [[THLabel alloc] initWithFrame:CGRectMake(0, playerHpBar.frame.origin.y - 4, deviceTypes.deviceWidth, 14)];
    playersCurrentMaxHealthLabel.textAlignment = NSTextAlignmentCenter;
    playersCurrentMaxHealthLabel.textColor = [UIColor whiteColor];
    playersCurrentMaxHealthLabel.strokeColor = [UIColor darkGrayColor];
    playersCurrentMaxHealthLabel.strokeSize = 2;
    playersCurrentMaxHealthLabel.strokePosition = THLabelStrokePositionOutside;
    playersCurrentMaxHealthLabel.font = [UIFont boldSystemFontOfSize:12];
    playersCurrentMaxHealthLabel.text = @"";
    [self addSubview:playersCurrentMaxHealthLabel];
    
    UIImage *opponentHpBackground = [UIImage imageNamed:@"opponentHpBarBG.png"];
    UIImageView *opponentHpBackgroundView = [[UIImageView alloc] initWithImage:opponentHpBackground];
    opponentHpBackgroundView.frame = CGRectMake(deviceTypes.deviceWidth / 2 - opponentHpBackground.size.width / 2, 28, opponentHpBackground.size.width, opponentHpBackground.size.height);
    [self addSubview:opponentHpBackgroundView];
    
    UIImage *opponentHpBarImage = [UIImage imageNamed:@"opponentHpBar.png"];
    opponentHpBar = [[UIImageView alloc] initWithImage:opponentHpBarImage];
    opponentHpBar.frame = CGRectMake(deviceTypes.deviceWidth / 2 - opponentHpBarImage.size.width / 2, 29, opponentHpBarImage.size.width, opponentHpBarImage.size.height);
    [self addSubview:opponentHpBar];
    
    opponentCurrentMaxHealthLabel = [[THLabel alloc] initWithFrame:CGRectMake(0, opponentHpBackgroundView.frame.origin.y - 4, deviceTypes.deviceWidth, 14)];
    opponentCurrentMaxHealthLabel.textAlignment = NSTextAlignmentCenter;
    opponentCurrentMaxHealthLabel.textColor = [UIColor whiteColor];
    opponentCurrentMaxHealthLabel.strokeColor = [UIColor darkGrayColor];
    opponentCurrentMaxHealthLabel.strokeSize = 2;
    opponentCurrentMaxHealthLabel.strokePosition = THLabelStrokePositionOutside;
    opponentCurrentMaxHealthLabel.font = [UIFont boldSystemFontOfSize:12];
    opponentCurrentMaxHealthLabel.text = @"";
    [self addSubview:opponentCurrentMaxHealthLabel];
    
    opponentHpBar100PercentWidth = opponentHpBarImage.size.width;
    playerHpBar100PercentWidth = playerHpBarImage.size.width;
    
    UIImage *headerImage = [UIImage imageNamed:@"gameModuleHeader.png"];
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:headerImage forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenuScreen:) forControlEvents:UIControlEventTouchUpInside];
    //UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    menuButton.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, headerImage.size.height);
    [self addSubview:menuButton];
    
    UIImage *numResImage = [UIImage imageNamed:@"numResurrectionsIcon.png"];
    UIImageView *numResView = [[UIImageView alloc] initWithImage:numResImage];
    numResView.frame = CGRectMake(deviceTypes.deviceWidth - numResImage.size.width - 2, 2, numResImage.size.width, numResImage.size.height);
    [self addSubview:numResView];
    
    numResurrectionsLabel = [[THLabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth - 13, 2, 20, 16)];
    numResurrectionsLabel.textAlignment = NSTextAlignmentLeft;
    numResurrectionsLabel.textColor = [UIColor whiteColor];
    numResurrectionsLabel.strokeColor = [UIColor darkGrayColor];
    numResurrectionsLabel.strokeSize = 1;
    numResurrectionsLabel.strokePosition = THLabelStrokePositionOutside;
    numResurrectionsLabel.font = [UIFont boldSystemFontOfSize:12];
    numResurrectionsLabel.text = [NSString stringWithFormat:@"%d", [[SaveLoadDataDevice sharedManager] getResurrections]];
    [self addSubview:numResurrectionsLabel];
    
}

- (void)showMenuScreen:(id)sender
{
    [delegate showTheGameMenu];
}

- (void)showDamageToPlayer:(int)playerDamage
{
    NSLog(@"Show player's damage.");
    PointBurst *pointBurst = [[PointBurst alloc] init];
    [pointBurst createPointBurstWithPoints:-playerDamage withColor:[UIColor redColor]];
    pointBurst.frame = CGRectMake(deviceTypes.deviceWidth / 2 - 25, 197, 50, 20);
    [self addSubview:pointBurst];
    
    [pointBurst setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    [pointBurst setEasingFunction:ExponentialEaseOut forKeyPath:@"alpha"];
    
    [UIView animateWithDuration:3.0 animations:^{
        
        pointBurst.frame = CGRectMake(deviceTypes.deviceWidth / 2 - 25, 197, 50, 20);
        [pointBurst setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
    [UIView animateWithDuration:3.0 animations:^{
        
        pointBurst.alpha = 0.0;
        [pointBurst setEasingFunction:BounceEaseOut forKeyPath:@"alpha"];
    }];
}

- (void)showDamageToOpponent:(int)opponentDamage
{
    
}

- (void)menuButtonSelected:(id)sender
{
    NSLog(@"Open menu");
}

- (void)updateScore:(int)score
{
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
}

- (void)scoreIncrementValue:(int)points
{
    pointsLabel.text = [NSString stringWithFormat:@"%d", points];
}

- (void)updatePlayerTotalHp:(float)total currentHp:(float)current
{
    NSLog(@"updatePlayerTotalHp:%f currentHp:%f.  opponentHpBar.width = %f", total, current, (int)opponentHpBar100PercentWidth * (current / total));
    if (current / total <= 0.00) {
        playerHpBar.frame = CGRectMake(playerHpBar.frame.origin.x, playerHpBar.frame.origin.y, 0, playerHpBar.frame.size.height);
        playersCurrentMaxHealthLabel.text = [NSString stringWithFormat:@"%d/%d", 0, (int)total];
        return;
    }
    playerHpBar.frame = CGRectMake(playerHpBar.frame.origin.x, playerHpBar.frame.origin.y, (int)playerHpBar100PercentWidth * (current / total), playerHpBar.frame.size.height);
    
    playersCurrentMaxHealthLabel.text = [NSString stringWithFormat:@"%d/%d", (int)current, (int)total];
}

- (void)updateOpponentTotalHp:(float)total currentHp:(float)current
{
    NSLog(@"updateOpponentTotalHp:%f currentHp:%f.  opponentHpBar.width = %f", total, current, (int)opponentHpBar100PercentWidth * (current / total));
    if (current / total <= 0.00) {
        opponentHpBar.frame = CGRectMake(opponentHpBar.frame.origin.x, opponentHpBar.frame.origin.y, 0, opponentHpBar.frame.size.height);
        opponentCurrentMaxHealthLabel.text = [NSString stringWithFormat:@"%d/%d", 0, (int)total];
        return;
    }
    opponentHpBar.frame = CGRectMake(opponentHpBar.frame.origin.x, opponentHpBar.frame.origin.y, (int)opponentHpBar100PercentWidth * (current / total), opponentHpBar.frame.size.height);
    
    opponentCurrentMaxHealthLabel.text = [NSString stringWithFormat:@"%d/%d", (int)current, (int)total];
}

- (void)updatePlayersMove:(int)damage
{
    //Do nothing probably
}

- (void)setBoost:(int)boostButtonIndex
{
    NSLog(@"boostButtonIndex = %d", boostButtonIndex);
    if (boostButtonIndex == 0) {
        UIImage *healthBoostButtonBgImage = [UIImage imageNamed:@"boostHudHealthBG.png"];
        healthBoostButtonBgImageView = [[UIImageView alloc] initWithImage:healthBoostButtonBgImage];
        healthBoostButtonBgImageView.frame = CGRectMake(boost1Pos.x, boost1Pos.y, healthBoostButtonBgImageView.frame.size.width, healthBoostButtonBgImageView.frame.size.height);
        [self addSubview:healthBoostButtonBgImageView];
        [boostsArray addObject:healthBoostButtonBgImageView];
        
        //UIImage *boostImage = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:boostButtonIndex] objectForKey:@"boostimagesmall"]];
        UIImage *boostImage = [UIImage imageNamed:@"boostHudHealth.png"];
        boostFullHealth = [UIButton buttonWithType:UIButtonTypeCustom];
        [boostFullHealth setImage:boostImage forState:UIControlStateNormal];
        [boostFullHealth addTarget:self action:@selector(restoreHealthBoostPressed:) forControlEvents:UIControlEventTouchUpInside];
        boostFullHealth.frame = CGRectMake(boost1Pos.x, boost1Pos.y, boostImage.size.width, boostImage.size.height);
        [self addSubview:boostFullHealth];
    } else if (boostButtonIndex == 1) {
        numBuffsUsed++;
        UIImage *defenseBoostIconImage = [UIImage imageNamed:@"greaterDefenseBoostSmall.png"];
        defenseBoostIconImageView = [[UIImageView alloc] initWithImage:defenseBoostIconImage];
        defenseBoostIconImageView.frame = CGRectMake(deviceTypes.deviceWidth - ((defenseBoostIconImage.size.width / 2) * numBuffsUsed) - (numBuffsUsed * 5), 25, defenseBoostIconImage.size.width / 2, defenseBoostIconImage.size.height / 2);
        
        [self addSubview:defenseBoostIconImageView];
        
        [self increaseDefense];
    } else if (boostButtonIndex == 2) {
        // repair boost
        numBuffsUsed++;
        UIImage *repairBoostIconImage = [UIImage imageNamed:@"greaterRepairBoostSmall.png"];
        repairBoostIconImageView = [[UIImageView alloc] initWithImage:repairBoostIconImage];
        repairBoostIconImageView.frame = CGRectMake(deviceTypes.deviceWidth - ((repairBoostIconImage.size.width / 2) * numBuffsUsed) - (numBuffsUsed * 5), 25, repairBoostIconImage.size.width / 2, repairBoostIconImage.size.height / 2);
        
        [self addSubview:repairBoostIconImageView];
        
        [self increaseAgility];
    } else if (boostButtonIndex == 3) {
        // attack boost
        numBuffsUsed++;
        UIImage *attackBoostIconImage = [UIImage imageNamed:@"greaterAttackBoostSmall.png"];
        attackBoostIconImageView = [[UIImageView alloc] initWithImage:attackBoostIconImage];
        attackBoostIconImageView.frame = CGRectMake(deviceTypes.deviceWidth - ((attackBoostIconImage.size.width / 2) * numBuffsUsed) - (numBuffsUsed * 5), 25, attackBoostIconImage.size.width / 2, attackBoostIconImage.size.height / 2);
        
        [self addSubview:attackBoostIconImageView];
        
        [self increaseAttack];
    } else if (boostButtonIndex == 4) {
        // resurrection boost
        numBuffsUsed++;
        UIImage *resurrectionBoostIconImage = [UIImage imageNamed:@"resurrectionBoostSmall.png"];
        resurrectionBoostImageView = [[UIImageView alloc] initWithImage:resurrectionBoostIconImage];
        resurrectionBoostImageView.frame = CGRectMake(deviceTypes.deviceWidth - ((resurrectionBoostIconImage.size.width / 2) * numBuffsUsed) - (numBuffsUsed * 5), 25, resurrectionBoostIconImage.size.width / 2, resurrectionBoostIconImage.size.height / 2);
        
        [self addSubview:resurrectionBoostImageView];
        
        [self sendResurrectionBoost];
    }
    
    [self animateButtonBackgrounds:boostsArray];
    
    NSLog(@"setBoost called. boostsData 0 : %@", [[boostsData getBoostsDataForBoostIndex:0] objectForKey:@"boostimagesmall"]);
}

- (void)animateButtonBackgrounds:(NSMutableArray *)images
{
    for (int i = 0; i < [images count]; i++) {
        [animations animateButtonBackground:[images objectAtIndex:i] withButtonIndex:i];
    }
}

- (void)restoreHealthBoostPressed:(id)sender
{
    NSLog(@"HealthBoost pressed from the PlayerHudModule.");
    boostFullHealth.alpha = 0.5;
    boostFullHealth.enabled = NO;
    [[BattleManager sharedManager] restoreHealth];
    [animations stopAnimatingButtonBackground:healthBoostButtonBgImageView withButtonIndex:[boostsArray indexOfObject:healthBoostButtonBgImageView]];
    [healthBoostButtonBgImageView removeFromSuperview];
}

- (void)increaseDefense
{
    [[BattleManager sharedManager] increaseDefense];
}

- (void)increaseAttack
{
    [[BattleManager sharedManager] increaseAttack];
}

- (void)increaseAgility
{
    [[BattleManager sharedManager] increaseAgility];
}

- (void)sendResurrectionBoost
{
    [[BattleManager sharedManager] enableResurrection];
}

- (void)resurrectionUsed
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 4.0];
    NSTimer *resurrectionTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(stopResurrectionAnimationAndUnlockPuzzle:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: resurrectionTimer forMode: NSDefaultRunLoopMode];
    [resurrectionBoostImageView removeFromSuperview];
    resurrectionBoostImageView = nil;
    
    UIImage *resurrectionRobotImage = [UIImage imageNamed:@"robotResurrection.png"];
    resurrectionRobotView = [[UIImageView alloc] initWithImage:resurrectionRobotImage];
    resurrectionRobotView.frame = CGRectMake(deviceTypes.deviceWidth / 2 - resurrectionRobotImage.size.width / 2, deviceTypes.deviceHeight / 2 - resurrectionRobotImage.size.height / 2, resurrectionRobotImage.size.width, resurrectionRobotImage.size.height);
    resurrectionRobotView.alpha = 0.0;
    [self addSubview:resurrectionRobotView];
    [animations fadeInView:resurrectionRobotView];
    
    [[AudioPlayer sharedManager] playResurrectionSound:1.0];
    
    [resurrectionRobotView setEasingFunction:ExponentialEaseIn forKeyPath:@"alpha"];
    
    [UIView animateWithDuration:4.0 animations:^{
        
        resurrectionRobotView.frame = CGRectMake(deviceTypes.deviceWidth / 2 - resurrectionRobotImage.size.width / 2, -resurrectionRobotView.frame.size.height, resurrectionRobotImage.size.width, resurrectionRobotImage.size.height);
    }];
}

- (void)stopResurrectionAnimationAndUnlockPuzzle:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
    [resurrectionRobotView removeFromSuperview];
    resurrectionRobotView = nil;
    [[BattleManager sharedManager] unlockPuzzleControl];
    [self updateResurrections];
}

- (void)updateResurrections
{
    numResurrectionsLabel.text = [NSString stringWithFormat:@"%d", [[SaveLoadDataDevice sharedManager] getResurrections]];
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
