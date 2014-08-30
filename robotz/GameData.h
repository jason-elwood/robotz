//
//  GameData.h
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameDataProtocol <NSObject>

- (void)updateCharacterSelectorDetails:(int)charIndex;

@end

@protocol GameDataScoreProtocol <NSObject>



@end

@interface GameData : NSObject
{
    
}

@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic, retain) NSString *currentCharacterName;
@property (nonatomic, retain) NSString *charClass;
@property int charClassType;
@property (readonly) int score;
@property (weak) id delegate;

+ (id)sharedManager;
- (void)setCurrentCharacterName:(NSString *)currentCharacterName;
- (void)updateCharacterSelectorDetails:(int)charIndex;
- (NSString *)getCurrentCharacterName;

@end
