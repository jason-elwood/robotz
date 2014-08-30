//
//  StartScreen.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "StartScreen.h"

@implementation StartScreen

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        deviceTypes = [[DeviceTypes alloc] init];
        
        // Background image
        startImage = [UIImage imageNamed:@"startScreeniPhone.png"];
        UIImageView *startImageView = [[UIImageView alloc] initWithImage:startImage];
        [startImageView setFrame:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
        [self addSubview:startImageView];
        
        UIImage *bottomImage = [UIImage imageNamed:@"startScreeniPhoneBottom.png"];
        UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:bottomImage];
        bottomImageView.frame = CGRectMake(0, deviceTypes.deviceHeight - bottomImage.size.height, bottomImage.size.width, bottomImage.size.height);
        [self addSubview:bottomImageView];
        
        // Play button
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButtonImage = [UIImage imageNamed:@"playButton.png"];
        [playButton setImage:playButtonImage forState:0];
        [playButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
        [playButton setFrame:CGRectMake(deviceTypes.deviceWidth / 2 - playButtonImage.size.width / 2, -playButtonImage.size.height, playButtonImage.size.width, playButtonImage.size.height)];
        [self addSubview:playButton];
        [playButton setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
        
        robotImage = [UIImage imageNamed:@"robot1.png"];
        robotImageView = [[UIImageView alloc] initWithImage:robotImage];
        robotImageView.frame = CGRectMake(deviceTypes.deviceWidth, deviceTypes.deviceHeight - robotImage.size.height - 30, robotImage.size.width, robotImage.size.height);
        [self addSubview:robotImageView];
        [robotImageView setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
        
        //[self displayFacebookButton];
        
        [self beginAnimation];
    }
    return self;
}

- (void)displayFacebookButton
{
    UIImage *facebookImage = [UIImage imageNamed:@"facebookButton.png"];
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - (facebookImage.size.width * 0.9) / 2, 300, facebookImage.size.width * 0.9, facebookImage.size.height * 0.9);
    [facebookButton setImage:facebookImage forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(facebookButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:facebookButton];
}

- (void)facebookButtonHandler:(id)sender
{
    [delegate showFacebookView];
}

- (void)beginAnimation
{
    // Start animate title timer.
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.2];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(animateRobot:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
    
    // Start animate start button timer.
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow: 0.4];
    NSTimer *animationTimer2 = [[NSTimer alloc] initWithFireDate:date2 interval:0.02 target:self selector:@selector(animatePlayButton:) userInfo:nil repeats:NO];
    NSRunLoop *runner2 = [NSRunLoop currentRunLoop];
    [runner2 addTimer: animationTimer2 forMode: NSDefaultRunLoopMode];
}

- (void)animateRobot:(NSTimer *)timer
{
    [UIView animateWithDuration:1.0 animations:^{
        
        robotImageView.frame = CGRectMake(deviceTypes.deviceWidth - robotImage.size.width + 25, deviceTypes.deviceHeight - robotImage.size.height - 30, robotImage.size.width, robotImage.size.height);
        
    }];
}

- (void)animatePlayButton:(NSTimer *)timer
{
    [UIView animateWithDuration:1.0 animations:^{
        
        playButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - playButtonImage.size.width / 2, 210, playButtonImage.size.width, playButtonImage.size.height);
        
    }];
}

- (void)startGame:(id) sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [delegate startGame];
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
