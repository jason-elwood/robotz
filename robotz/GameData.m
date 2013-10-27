//
//  GameData.m
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "GameData.h"

@implementation GameData

@synthesize someProperty, delegate, score, currentCharacterName = _currentCharacterName;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static GameData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
        _currentCharacterName = @"Default";
    }
    return self;
}

- (void)setCurrentCharacterName:(NSString *)currentCharacterName
{
    _currentCharacterName = currentCharacterName;
}

- (NSString *)getCurrentCharacterName
{
    return _currentCharacterName;
}

- (void)updateCharacterSelectorDetails:(int)charIndex
{
    [delegate updateCharacterSelectorDetails:charIndex];
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
