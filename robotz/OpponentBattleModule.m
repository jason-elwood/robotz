//
//  OpponentBattleModule.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "OpponentBattleModule.h"

@implementation OpponentBattleModule

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        deviceTypes = [[DeviceTypes alloc] init];
        animations = [[AnimationsClass alloc] init];
        BattleManager *bm = [BattleManager sharedManager];
        bm.delegateOpponent = self;
        [bm provideOpponentBattleModuleUI];
        //[self initializeUI];
    }
    return self;
}

- (void)initializeUIWithBgImage:(NSString *)bg andRobotImage:(NSString *)robot
{
    NSLog(@"initializeUIWithBgImage:%@ andRobotImage:%@", bg, robot);
    UIImage *bgImage = [UIImage imageNamed:bg];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [self addSubview:bgImageView];
    
    UIImage *robotImage = [UIImage imageNamed:robot];
    robotImageView = [[UIImageView alloc] initWithImage:robotImage];
    robotImageView.contentMode = UIViewContentModeScaleAspectFit;
    robotImageView.frame = CGRectMake(deviceTypes.deviceWidth / 2 - robotImage.size.width / 2, 35, robotImage.size.width, 160);
    [self addSubview:robotImageView];
    
    UIImage *healthBarCoverImage = [UIImage imageNamed:@"gameModuleHealthBarCover.png"];
    UIImageView *healthBarCoverImageView = [[UIImageView alloc] initWithImage:healthBarCoverImage];
    healthBarCoverImageView.frame = CGRectMake(0, 215 - healthBarCoverImage.size.height, deviceTypes.deviceWidth, healthBarCoverImage.size.height);
    [self addSubview:healthBarCoverImageView];
    
}

- (void)updatePlayersMove:(int)damage
{
    PointBurst *pointBurst = [[PointBurst alloc] initWithFrame:CGRectMake([self randomIntBetween:95 and:175], [self randomIntBetween:100 and:150], 50, 20)];
    [pointBurst createPointBurstWithPoints:damage withColor:[UIColor redColor]];
    [self addSubview:pointBurst];
    [pointBurst setEasingFunction:ExponentialEaseOut forKeyPath:@"alpha"];
    [pointBurst setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    [UIView animateWithDuration:3.0 animations:^{
        
        pointBurst.alpha = 0;
        [pointBurst setEasingFunction:BounceEaseOut forKeyPath:@"alpha"];
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        pointBurst.frame = CGRectMake([self randomIntBetween:125 and:145], [self randomIntBetween:70 and:90], 50, 20);
        [pointBurst setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
    
    [self opponentTakesHit];
}

- (void)showPlayersAttackAnimation:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
}

-(NSInteger)randomIntBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform(max + 1 - min));
}

- (void)updateOpponentsMove:(int)type
{
    [self opponentAttacks];
}

- (void)opponentTakesHit
{
    NSLog(@"opponentTakesHit");
    [animations shake:robotImageView];
}

- (void)opponentDefeated
{
    [robotImageView setEasingFunction:ExponentialEaseOut forKeyPath:@"alpha"];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        robotImageView.alpha = 0;
        [robotImageView setEasingFunction:BounceEaseOut forKeyPath:@"alpha"];
    }];
}

- (void)opponentAttacks
{
    NSLog(@"opponentAttacks");
    UIImage *fireballImage = [UIImage imageNamed:@"fireball2.png"];
    fireballImageView = [[UIImageView alloc] initWithImage:fireballImage];
    fireballImageView.frame = CGRectMake(-10, 65, fireballImage.size.width, fireballImage.size.height);
    [self addSubview:fireballImageView];
    [animations fireball:fireballImageView startPos:CGPointMake(160, 50) endPos:CGPointMake(0, 150) duration:0.4];
//
    UIImage *fireballImage2 = [UIImage imageNamed:@"fireball2.png"];
    fireballImageView2 = [[UIImageView alloc] initWithImage:fireballImage2];
    fireballImageView2.frame = CGRectMake(-10, 65, fireballImage2.size.width, fireballImage2.size.height);
    [self addSubview:fireballImageView2];
    [animations fireball:fireballImageView2 startPos:CGPointMake(160, 50) endPos:CGPointMake(160, 150) duration:0.4];
//
    UIImage *fireballImage3 = [UIImage imageNamed:@"fireball2.png"];
    fireballImageView3 = [[UIImageView alloc] initWithImage:fireballImage3];
    fireballImageView3.frame = CGRectMake(-10, 65, fireballImage.size.width, fireballImage.size.height);
    [self addSubview:fireballImageView3];
    [animations fireball:fireballImageView3 startPos:CGPointMake(160, 50) endPos:CGPointMake(320, 150) duration:0.4];
    
    [[BattleManager sharedManager] playerTakesDamage];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(clearAttack:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
    
}

- (void)clearAttack:(NSTimer *)timer
{
    [fireballImageView removeFromSuperview];
    fireballImageView = nil;
    [fireballImageView2 removeFromSuperview];
    fireballImageView2 = nil;
    [fireballImageView3 removeFromSuperview];
    fireballImageView3 = nil;
    [animationTimer invalidate];
    animationTimer = nil;
}

- (void)updatePlayerTotalHp:(float)total currentHp:(float)current
{
    
}

- (void)updateScore:(int)score
{
    NSLog(@"updateScoreeeeeee");
}

- (void)scoreIncrementValue:(int)points
{
    NSLog(@"scoreIncrementValue");
}

- (void)updateOpponentTotalHp:(float)total currentHp:(float)current
{
    
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
