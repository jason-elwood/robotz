//
//  GameMenu.m
//  robotz
//
//  Created by Jason Elwood on 10/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "GameMenu.h"

@implementation GameMenu

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
    UIImage *bgImage = [UIImage imageNamed:@"gameMenuBG.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [self addSubview:bgImageView];
    
    UIImage *closeButtonImage = [UIImage imageNamed:@"backButton.png"];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - closeButtonImage.size.width / 2, 370, closeButtonImage.size.width, closeButtonImage.size.height)];
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    [self createSettingsList];
    
}

- (void)createSettingsList
{
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 85, 220, 30)];
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
    
    UILabel *soundFxLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 135, 220, 30)];
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
    
    UILabel *quitLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 185, 220, 30)];
    [quitLabel setText:@"Quit Match"];
    [quitLabel setTextColor:[UIColor darkGrayColor]];
    [self addSubview:quitLabel];
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quitButton.layer.cornerRadius = 5;
    quitButton.layer.borderWidth = 2;
    quitButton.layer.borderColor = [UIColor colorWithRed:28.0f/255.0f green:130.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    quitButton.frame = CGRectMake(185, 185, 70, 30);
    [quitButton setTitle:@"QUIT" forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitMatch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:quitButton];
    
    UIImageView *hr3 = [[UIImageView alloc] initWithImage:hr];
    hr3.frame = CGRectMake(deviceTypes.deviceWidth / 2 - hr.size.width / 2, 223, hr.size.width, hr.size.height);
    [self addSubview:hr3];
    
}

- (void)quitMatch:(id)sender
{
    UIAlertView *quitMatchView = [[UIAlertView alloc] initWithTitle:@"Quit Match" message:@"All experience and points earned will be lost.\nAre you sure you want to quit?" delegate:self cancelButtonTitle:@"QUIT" otherButtonTitles:@"CANCEL", nil];
    [quitMatchView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertView buttonIndex : %d", buttonIndex);
    if (buttonIndex == 0) {
        [delegate quitMatch];
    } else {
        // Cancel touched
    }
}

- (void)updateMusicSettings:(id)sender
{
    BOOL state = [sender isOn];
    [[SaveLoadDataDevice sharedManager] setMusicOn:state];
    if (!state) {
        [[AudioPlayer sharedManager] turnOffAllMusic];
    } else {
        [[AudioPlayer sharedManager] turnOnAllMusic:constants.MUSICBATTLESCREEN];
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

- (void)closeMenu:(id)sender
{
    [delegate hideGameMenu];
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
