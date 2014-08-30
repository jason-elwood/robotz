//
//  AudioPlayer.h
//  robotz
//
//  Created by Jason Elwood on 10/3/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"

@protocol AudioPlayerProtocol <NSObject>

- (void) setCurrentlyPlayingMusic:(NSString *)music;
- (NSString *)getCurrentlyPlayingMusic;

@end

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate>
{
    Constants *constants;
    
    AVAudioPlayer *battleMusicPlayer;
    AVAudioPlayer *mainMenuPlayer;
    AVAudioPlayer *startScreenPlayer;
    AVAudioPlayer *battleWonPlayer;
    AVAudioPlayer *battleLostPlayer;
    AVAudioPlayer *buttonPressSound;
    AVAudioPlayer *viewOpenCloseSound;
    AVAudioPlayer *swapPiecesSound;
    AVAudioPlayer *voiceNiceSound;
    AVAudioPlayer *voiceAwesomeSound;
    AVAudioPlayer *voiceGreatSound;
    AVAudioPlayer *pieceTapSound;
    AVAudioPlayer *resurrectionSound;
    
    AVAudioPlayer *musicCurrentlyPlaying;
    
    NSTimer *musicStopTimer;
    
    BOOL playMusic;
    BOOL playSoundFx;
    BOOL musicIsPlaying;
}

@property (weak) id <AudioPlayerProtocol>delegate;

+ (id)sharedManager;

- (void)initializeSounds;

- (void)PlayMusic:(NSString*)strSoundFileName atVolume:(float)vol;
- (void)AdjustVolume:(float)volume;
- (void)PauseMusic:(NSString *)strSoundFileName;

- (void)PlayButtonPressSoundAtVolume:(float)vol;
- (void)PlayViewOpenClose:(float)vol;
- (void)playAwesomeVoiceAtVolume:(float)vol;
- (void)playGreatVoiceAtVolume:(float)vol;
- (void)playNiceVoiceAtVolume:(float)vol;
- (void)playPieceTapSoundAtVolume:(float)vol;
- (void)playResurrectionSound:(float)vol;

- (void)turnOffAllSoundFx;
- (void)turnOffAllMusic;
- (void)turnOnAllMusic:(NSString *)musicString;
- (void)turnOnAllSoundFx;

- (void)playSound :(NSString *)fName :(NSString *) ext;

@end
