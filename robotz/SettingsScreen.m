//
//  SettingsScreen.m
//  robotz
//
//  Created by Jason Elwood on 10/5/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "SettingsScreen.h"

@implementation SettingsScreen

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        constants = [[Constants alloc] init];
        deviceTypes = [[DeviceTypes alloc] init];
        [self drawSettingsScreen];
    }
    return self;
}

- (void)drawSettingsScreen
{
    UIImage *bgImage = [UIImage imageNamed:@"settingsPageBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [self addSubview:bgImageView];
    
    UIImage *closeButtonImage = [UIImage imageNamed:@"closeButtonSettings.png"];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - closeButtonImage.size.width / 2, 370, closeButtonImage.size.width, closeButtonImage.size.height)];
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    [self createSettingsList];
    
}

- (void)createSettingsList
{
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 85, 220, 30)];
    [musicLabel setText:@"Music"];
    [musicLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:musicLabel];
    
    UISwitch *musicSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 85, 50, 100)];
    [self addSubview:musicSwitch];
    
    [musicSwitch setOn:[[SaveLoadDataDevice sharedManager] getMusicOn]];
    [musicSwitch addTarget:self action:@selector(updateMusicSettings:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *hr = [UIImage imageNamed:@"settingsHorizontalRule.png"];
    UIImageView *hr1 = [[UIImageView alloc] initWithImage:hr];
    hr1.frame = CGRectMake(deviceTypes.deviceWidth / 2 - hr.size.width / 2, 125, hr.size.width, hr.size.height);
    [self addSubview:hr1];
    
    UILabel *soundFxLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 135, 220, 30)];
    [soundFxLabel setText:@"Sound FX"];
    [soundFxLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:soundFxLabel];
    
    UISwitch *soundFxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 135, 50, 100)];
    [self addSubview:soundFxSwitch];
    
    [soundFxSwitch setOn:[[SaveLoadDataDevice sharedManager] getSoundFxOn]];
    [soundFxSwitch addTarget:self action:@selector(updateSoundFxSettings:) forControlEvents:UIControlEventValueChanged];
    
    UIImageView *hr2 = [[UIImageView alloc] initWithImage:hr];
    hr2.frame = CGRectMake(deviceTypes.deviceWidth / 2 - hr.size.width / 2, 174, hr.size.width, hr.size.height);
    [self addSubview:hr2];
    
    
    UILabel *creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 185, 220, 30)];
    [creditsLabel setText:@"Credits"];
    [creditsLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:creditsLabel];
    
    UIButton *creditsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    creditsButton.layer.cornerRadius = 5;
    creditsButton.layer.borderWidth = 2;
    creditsButton.layer.borderColor = [UIColor colorWithRed:28.0f/255.0f green:130.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    creditsButton.frame = CGRectMake(185, 184, 70, 30);
    [creditsButton setTitle:@"VIEW" forState:UIControlStateNormal];
    [creditsButton addTarget:self action:@selector(showTheCreditsScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:creditsButton];
    
    UIImageView *hr3 = [[UIImageView alloc] initWithImage:hr];
    hr3.frame = CGRectMake(deviceTypes.deviceWidth / 2 - hr.size.width / 2, 223, hr.size.width, hr.size.height);
    [self addSubview:hr3];
    
    UILabel *resetGameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 235, 220, 30)];
    [resetGameLabel setText:@"Reset Game"];
    [resetGameLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:resetGameLabel];
    
    UIButton *resetGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resetGameButton.layer.cornerRadius = 5;
    resetGameButton.layer.borderWidth = 2;
    resetGameButton.layer.borderColor = [UIColor colorWithRed:28.0f/255.0f green:130.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    resetGameButton.frame = CGRectMake(185, 234, 70, 30);
    [resetGameButton setTitle:@"RESET" forState:UIControlStateNormal];
    [resetGameButton addTarget:self action:@selector(resetGame:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetGameButton];
    
    UIImageView *hr4 = [[UIImageView alloc] initWithImage:hr];
    hr4.frame = CGRectMake(deviceTypes.deviceWidth / 2 - hr.size.width / 2, 273, hr.size.width, hr.size.height);
    [self addSubview:hr4];
    
    UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 285, 220, 30)];
    [helpLabel setText:@"Help"];
    [helpLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:helpLabel];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    helpButton.layer.cornerRadius = 5;
    helpButton.layer.borderWidth = 2;
    helpButton.layer.borderColor = [UIColor colorWithRed:28.0f/255.0f green:130.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    helpButton.frame = CGRectMake(185, 283, 70, 30);
    [helpButton setTitle:@"VIEW" forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(startHelpTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:helpButton];
    
    UIImageView *hr5 = [[UIImageView alloc] initWithImage:hr];
    hr5.frame = CGRectMake(deviceTypes.deviceWidth / 2 - hr.size.width / 2, 323, hr.size.width, hr.size.height);
    [self addSubview:hr5];
    
    
}

- (void)startHelpTutorial:(id)sender
{
    blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    blackBG.alpha = 0.7;
    blackBG.backgroundColor = [UIColor blackColor];
    [self addSubview:blackBG];
    
    /***************************************  Tutorial screen 1 ***************************************/
    
    UIImage *tut1Image = [UIImage imageNamed:@"howToPlay1.png"];
    tut1ImageView = [[UIImageView alloc] initWithImage:tut1Image];
    tut1ImageView.frame = CGRectMake(0, 0, tut1Image.size.width, tut1Image.size.height);
    
    tutWidth = tut1Image.size.width;
    tutHeight = tut1Image.size.height;
    
    tut1Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut1Image.size.width, tut1Image.size.height + 50)];
    
    UIImage *buttonImage = [UIImage imageNamed:@"nextButton.png"];
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:buttonImage forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(closeTutorialScreen1:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - buttonImage.size.width / 2 - 20, tut1ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut1Container];
    [tut1Container addSubview:tut1ImageView];
    [tut1Container addSubview:nextButton];
    [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *animTut1Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(displayTutorialScreen1:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut1Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
    
    /***************************************  Tutorial screen 2 ***************************************/
    
    UIImage *tut2Image = [UIImage imageNamed:@"howToPlay2.png"];
    tut2ImageView = [[UIImageView alloc] initWithImage:tut2Image];
    tut2ImageView.frame = CGRectMake(0, 0, tut2Image.size.width, tut2Image.size.height);
    
    tut2Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut2Image.size.width, tut2Image.size.height + 50)];
    
    nextButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton2 setImage:buttonImage forState:UIControlStateNormal];
    [nextButton2 addTarget:self action:@selector(closeTutorialScreen2:) forControlEvents:UIControlEventTouchUpInside];
    nextButton2.frame = CGRectMake(deviceTypes.deviceWidth / 2 - buttonImage.size.width / 2 - 20, tut2ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut2Container];
    [tut2Container addSubview:tut2ImageView];
    [tut2Container addSubview:nextButton2];
    [tut2Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    /***************************************  Tutorial screen 3 ***************************************/
    
    UIImage *tut3Image = [UIImage imageNamed:@"howToPlay3.png"];
    tut3ImageView = [[UIImageView alloc] initWithImage:tut3Image];
    tut3ImageView.frame = CGRectMake(0, 0, tut3Image.size.width, tut3Image.size.height);
    
    tut3Container = [[UIView alloc] initWithFrame:CGRectMake(0, deviceTypes.deviceHeight, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    
    nextButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton3 setImage:buttonImage forState:UIControlStateNormal];
    [nextButton3 addTarget:self action:@selector(closeTutorialScreen3:) forControlEvents:UIControlEventTouchUpInside];
    nextButton3.frame = CGRectMake(deviceTypes.deviceWidth / 2 - buttonImage.size.width / 2, 365, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut3Container];
    [tut3Container addSubview:tut3ImageView];
    [tut3Container addSubview:nextButton3];
    [tut3Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
}

- (void)displayTutorialScreen1:(NSTimer *)timer
{
    //NSLog(@"displayTutorialScreen1");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut1Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight / 2 - tutHeight / 2, tutWidth, tutHeight);
        [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    [tut1Container setEasingFunction:ExponentialEaseIn forKeyPath:@"frame"];
    
    [timer invalidate];
    timer = nil;
}

- (void)closeTutorialScreen1:(id)sender
{
    //NSLog(@"closeTutorialScreen1");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut1Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut1ImageView.frame.size.width, tut1ImageView.frame.size.height);
        [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *animTut2Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(displayTutorialScreen2:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut2Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)displayTutorialScreen2:(NSTimer *)timer
{
    //NSLog(@"displayTutorialScreen2");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut2Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight / 2 - tutHeight / 2, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
    }];
    
    [tut2Container setEasingFunction:ExponentialEaseIn forKeyPath:@"frame"];
    
    [timer invalidate];
    timer = nil;
}

- (void)closeTutorialScreen2:(id)sender
{
    //NSLog(@"closeTutorialScreen2");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut2Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut2ImageView.frame.size.width, tut2ImageView.frame.size.height);
        [tut2Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *animTut3Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(displayTutorialScreen3:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut3Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)displayTutorialScreen3:(NSTimer *)timer
{
    //NSLog(@"displayTutorialScreen3");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut3Container.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
    }];
    
    [tut3Container setEasingFunction:ExponentialEaseIn forKeyPath:@"frame"];
    
    [timer invalidate];
    timer = nil;
}

- (void)closeTutorialScreen3:(id)sender
{
    //NSLog(@"closeTutorialScreen3");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut3Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut3ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut3ImageView.frame.size.width, tut3ImageView.frame.size.height);
        [tut3Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *animTut3Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(hideBlackBG:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut3Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)hideBlackBG:(NSTimer *)timer
{
    blackBG.alpha -= 0.02;
    if (blackBG.alpha <= 0.0) {
        [timer invalidate];
        timer = nil;
        [blackBG removeFromSuperview];
        [tut1Container removeFromSuperview];
        tut1Container = nil;
        [tut2Container removeFromSuperview];
        tut2Container = nil;
        [tut3Container removeFromSuperview];
        tut3Container = nil;
    }
}

- (void)resetGame:(id)sender
{
    UIAlertView *resetGameAlert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"Resetting the game will reset your character and game history.  You will not lose your coins." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I'm Sure", nil];
    [resetGameAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancel"])
    {
        // Do nothing
    } else {
        [[SaveLoadDataDevice sharedManager] resetCharacter];
        [delegate viewDidLoad];
    }
}

- (void)showTheCreditsScreen:(id)sender
{
    [delegate showCreditsScreen];
}

- (void)updateMusicSettings:(id)sender
{
    BOOL state = [sender isOn];
    [[SaveLoadDataDevice sharedManager] setMusicOn:state];
    if (!state) {
        [[AudioPlayer sharedManager] turnOffAllMusic];
    } else {
        [[AudioPlayer sharedManager] turnOnAllMusic:constants.MUSICMAINMENU];
    }
}

- (void)updateSoundFxSettings:(id)sender
{
    BOOL state = [sender isOn];
    [[SaveLoadDataDevice sharedManager] setSoundFxOn:state];
    if (!state) {
        [[AudioPlayer sharedManager] turnOffAllSoundFx];
    } else {
        [[AudioPlayer sharedManager] turnOnAllSoundFx];
    }
}

- (void)closeSettings:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [delegate closeSettingsScreen];
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
