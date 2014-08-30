//
//  AudioPlayer.m
//  robotz
//
//  Created by Jason Elwood on 10/3/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

@synthesize delegate;

+ (id)sharedManager {
    static AudioPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

- (void)initializeSounds
{
    playMusic = YES;
    playSoundFx = YES;
    musicIsPlaying = NO;
    
    constants = [[Constants alloc] init];
    
    NSURL *buttonSoundURL = [[NSBundle mainBundle] URLForResource:@"ButtonTouch"
                                              withExtension:@"wav"];
    NSURL *awesomeSoundURL = [[NSBundle mainBundle] URLForResource:@"voiceAwesome"
                                              withExtension:@"aif"];
    NSURL *greatSoundURL = [[NSBundle mainBundle] URLForResource:@"voiceGreat"
                                              withExtension:@"aif"];
    NSURL *niceSoundURL = [[NSBundle mainBundle] URLForResource:@"voiceNice"
                                                  withExtension:@"aif"];
    NSURL *viewOpenCloseURL = [[NSBundle mainBundle] URLForResource:@"WoodenPanelOpen"
                                                      withExtension:@"wav"];
    NSURL *pieceTapSoundURL = [[NSBundle mainBundle] URLForResource:@"pieceTapSound"
                                                      withExtension:@"aif"];
    NSURL *resurrectionSoundURL = [[NSBundle mainBundle] URLForResource:@"resurrection"
                                                          withExtension:@"wav"];
    
    buttonPressSound = [[AVAudioPlayer alloc] initWithContentsOfURL:buttonSoundURL error:nil];
    [buttonPressSound setVolume:0.0];
    [buttonPressSound play];
    
    voiceAwesomeSound = [[AVAudioPlayer alloc] initWithContentsOfURL:awesomeSoundURL error:nil];
    [voiceAwesomeSound setVolume:0.0];
    [voiceAwesomeSound play];
    
    voiceGreatSound = [[AVAudioPlayer alloc] initWithContentsOfURL:greatSoundURL error:nil];
    [voiceGreatSound setVolume:0.0];
    [voiceGreatSound play];
    
    voiceNiceSound = [[AVAudioPlayer alloc] initWithContentsOfURL:niceSoundURL error:nil];
    [voiceNiceSound setVolume:0.0];
    [voiceNiceSound play];
    
    viewOpenCloseSound = [[AVAudioPlayer alloc] initWithContentsOfURL:viewOpenCloseURL error:nil];
    [viewOpenCloseSound setVolume:0.0];
    [viewOpenCloseSound play];
    
    pieceTapSound = [[AVAudioPlayer alloc] initWithContentsOfURL:pieceTapSoundURL error:nil];
    [pieceTapSound setVolume:0.0];
    [pieceTapSound play];
    
    resurrectionSound = [[AVAudioPlayer alloc] initWithContentsOfURL:resurrectionSoundURL error:nil];
    [resurrectionSound setVolume:0.0];
    [resurrectionSound play];
}

- (void)playSound :(NSString *)fName :(NSString *) ext{
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else {
        //NSLog(@"error, file not found: %@", path);
    }
}

- (void)stopCurrentMusic:(AVAudioPlayer *)player
{
    [self StopMusic:player];
    musicIsPlaying = NO;
    //NSLog(@"stopping music : %@", player);
}

- (void)PlayMusic:(NSString*)strSoundFileName atVolume:(float)vol
{
    if (!playMusic) {
        vol = 0.0;
    }
    
    if (musicIsPlaying) {
        [self stopCurrentMusic:musicCurrentlyPlaying];
    }
    
    NSURL *url= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], strSoundFileName]];
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] init];
    if ([strSoundFileName isEqualToString:constants.MUSICMAINMENU]) {
        player = mainMenuPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        musicCurrentlyPlaying = mainMenuPlayer;
    } else if ([strSoundFileName isEqualToString:constants.MUSICBATTLESCREEN]) {
        player = battleMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        musicCurrentlyPlaying = battleMusicPlayer;
    } else if ([strSoundFileName isEqualToString:constants.MUSICSTARTSCREEN]) {
        player = startScreenPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        musicCurrentlyPlaying = startScreenPlayer;
    } else if ([strSoundFileName isEqualToString:constants.MUSICBATTLEWON]) {
        player = battleWonPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        musicCurrentlyPlaying = battleWonPlayer;
    } else if ([strSoundFileName isEqualToString:constants.MUSICBATTLELOST]) {
        player = battleLostPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        musicCurrentlyPlaying = battleLostPlayer;
    } else {
        return;
    }
    
    musicIsPlaying = YES;
	
	player.numberOfLoops = -1;
    player.volume = vol;
    
	if (player == nil)
		NSLog(@"%@",[error description]); // The way this method is currently set up (a string check with a return), this will never get called.
	else
		[player play];
}

- (void)playPieceTapSoundAtVolume:(float)vol
{
    if (!playSoundFx) {
        return;
    }
    [self playSound:@"pieceTapSound" :@"aif"];
    
}

- (void)PlayButtonPressSoundAtVolume:(float)vol
{
    if (!playSoundFx) {
        return;
    }
    [self playSound:@"ButtonTouch" :@"wav"];
}

- (void)PlayViewOpenClose:(float)vol
{
    if (!playSoundFx) {
        return;
    }
    [self playSound:@"WoodenPanelOpen" :@"wav"];
}

- (void)playAwesomeVoiceAtVolume:(float)vol
{
    if (!playSoundFx) {
        return;
    }
    [self playSound:@"voiceAwesome" :@"aif"];
}

- (void)playGreatVoiceAtVolume:(float)vol
{
    if (!playSoundFx) {
        return;
    }
    [self playSound:@"voiceGreat" :@"aif"];
}

- (void)playNiceVoiceAtVolume:(float)vol
{
    if (!playSoundFx) {
        return;
    }
    [self playSound:@"voiceNice" :@"aif"];
}

- (void)playResurrectionSound:(float)vol
{
    if (!playSoundFx) {
        return;
    }
    [self playSound:@"resurrection" :@"wav"];
}

- (void)AdjustVolume:(float)volume
{
    //gameMusicPlayer.volume = volume;
}

- (void)StopMusic:(AVAudioPlayer *)player
{
    if (!playMusic) {
        return;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    musicStopTimer = [[NSTimer alloc] initWithFireDate:date interval:0.05 target:self selector:@selector(fadeVolumeOut:) userInfo:player repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: musicStopTimer forMode: NSDefaultRunLoopMode];
}

- (void)fadeVolumeOut:(NSTimer *)timer
{
    AVAudioPlayer *player = [timer userInfo];
    player.volume -= 0.05;
    if (player.volume <= 0.0) {
        [player stop];
        player.volume = 0.0;
        [musicStopTimer invalidate];
        musicStopTimer = nil;
        player = nil;
    }
}

- (void)turnOffAllSoundFx
{
   // NSLog(@"turnOffAllSoundFx");
    playSoundFx = NO;
}

- (void)turnOffAllMusic
{
    NSLog(@"turnOffAllMusic");
    //[self StopMusic:musicCurrentlyPlaying];
    musicCurrentlyPlaying.volume = 0.0;
    playMusic = NO;
}

- (void)turnOnAllMusic:(NSString *)musicString
{
    //NSLog(@"turnOnAllMusic");
    playMusic = YES;
    if ([musicString isEqualToString:constants.MUSICMAINMENU]) {
        [self PlayMusic:constants.MUSICMAINMENU atVolume:1.0];
        [delegate setCurrentlyPlayingMusic:constants.MUSICMAINMENU];
    } else if ([musicString isEqualToString:constants.MUSICBATTLESCREEN]) {
        [self PlayMusic:constants.MUSICBATTLESCREEN atVolume:1.0];
        [delegate setCurrentlyPlayingMusic:constants.MUSICBATTLESCREEN];
    }
}

- (void)turnOnAllSoundFx
{
    //NSLog(@"turnOnAllSoundFx");
    playSoundFx = YES;
}

- (void)PauseMusic:(NSString *)strSoundFileName;
{
    //[gameMusicPlayer pause];
}

@end
