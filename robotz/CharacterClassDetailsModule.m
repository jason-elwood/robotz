//
//  CharacterClassDetailsModule.m
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CharacterClassDetailsModule.h"

@implementation CharacterClassDetailsModule

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        characterIndex = 0;
        // Initialization code
        deviceTypes = [[DeviceTypes alloc] init];
        charClassData = [[CharacterClassData alloc] init];
        constants = [[Constants alloc] init];
        charLevelData = [[CharLevelData alloc] init];
        GameData *gameDataSharedClass = [GameData sharedManager];
        gameDataSharedClass.delegate = self;
        
        charDetailsBgImage = [UIImage imageNamed:@"charClassDetailsBG.png"];
        // Background image
        UIImageView *charDetailsBgImageView = [[UIImageView alloc] initWithImage:charDetailsBgImage];
        [charDetailsBgImageView setFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, charDetailsBgImage.size.height)];
        [self addSubview:charDetailsBgImageView];
        
        // Choose Class Button
        UIImage *chooseClassButtonImage = [UIImage imageNamed:@"chooseClassButton.png"];
        UIButton *chooseClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseClassButton setImage:chooseClassButtonImage forState:0];
        [chooseClassButton addTarget:self action:@selector(chooseCharClass:) forControlEvents:UIControlEventTouchUpInside];
        [chooseClassButton setFrame:CGRectMake(deviceTypes.deviceWidth / 2 - chooseClassButtonImage.size.width / 2, 15, chooseClassButtonImage.size.width, chooseClassButtonImage.size.height)];
        [self addSubview:chooseClassButton];
        
        classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, deviceTypes.deviceWidth, 30)];
        classNameLabel.textAlignment = NSTextAlignmentCenter;
        classNameLabel.textColor = [UIColor whiteColor];
        [classNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
        [self addSubview:classNameLabel];
        
        classDescLabel = [[UITextView alloc] initWithFrame:CGRectMake(5, 90, deviceTypes.deviceWidth - 10, 75)];
        classDescLabel.editable = NO;
        classDescLabel.textAlignment = NSTextAlignmentLeft;
        classDescLabel.textColor = [UIColor whiteColor];
        classDescLabel.backgroundColor = [UIColor clearColor];
        [classDescLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:classDescLabel];
        
        attackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, deviceTypes.deviceWidth / 2 - 5, 20)];
        attackLabel.textAlignment = NSTextAlignmentRight;
        attackLabel.textColor = [UIColor whiteColor];
        [attackLabel setFont:[UIFont boldSystemFontOfSize:18]];
        attackLabel.text = @"Attack:";
        [self addSubview:attackLabel];
        
        defenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 177, deviceTypes.deviceWidth / 2 - 5, 20)];
        defenseLabel.textAlignment = NSTextAlignmentRight;
        defenseLabel.textColor = [UIColor whiteColor];
        [defenseLabel setFont:[UIFont boldSystemFontOfSize:18]];
        defenseLabel.text = @"Defense:";
        [self addSubview:defenseLabel];
        
        repairLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 194, deviceTypes.deviceWidth / 2 - 5, 20)];
        repairLabel.textAlignment = NSTextAlignmentRight;
        repairLabel.textColor = [UIColor whiteColor];
        [repairLabel setFont:[UIFont boldSystemFontOfSize:18]];
        repairLabel.text = @"Repair:";
        [self addSubview:repairLabel];
        
        agilityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 211, deviceTypes.deviceWidth / 2 - 5, 20)];
        agilityLabel.textAlignment = NSTextAlignmentRight;
        agilityLabel.textColor = [UIColor whiteColor];
        [agilityLabel setFont:[UIFont boldSystemFontOfSize:18]];
        agilityLabel.text = @"Agility:";
        [self addSubview:agilityLabel];
        
        attackValue = [[UILabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 + 5, 160, deviceTypes.deviceWidth / 2 - 5, 20)];
        attackValue.textAlignment = NSTextAlignmentLeft;
        attackValue.textColor = [UIColor blueColor];
        [attackValue setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:attackValue];
        
        defenseValue = [[UILabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 + 5, 177, deviceTypes.deviceWidth / 2 - 5, 20)];
        defenseValue.textAlignment = NSTextAlignmentLeft;
        defenseValue.textColor = [UIColor blueColor];
        [defenseValue setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:defenseValue];
        
        repairValue = [[UILabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 + 5, 194, deviceTypes.deviceWidth / 2 - 5, 20)];
        repairValue.textAlignment = NSTextAlignmentLeft;
        repairValue.textColor = [UIColor blueColor];
        [repairValue setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:repairValue];
        
        agilityValue = [[UILabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 + 5, 211, deviceTypes.deviceWidth / 2 - 5, 20)];
        agilityValue.textAlignment = NSTextAlignmentLeft;
        agilityValue.textColor = [UIColor blueColor];
        [agilityValue setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:agilityValue];
        
        [self updateCharacterSelectorDetails:0];
    }
    return self;
}

- (void)updateCharacterSelectorDetails:(int)charIndex
{
    NSLog(@"Update character stats.");
    characterIndex = charIndex;
    charDataDictionary = [[NSDictionary alloc] initWithDictionary:[charClassData getCharClassData:charIndex]];
    [classNameLabel setText:[charDataDictionary objectForKey:constants.CLASSNAME]];
    [classDescLabel setText:[charDataDictionary objectForKey:constants.CLASSDESC]];
    [attackValue setText:[NSString stringWithFormat:@"%d", [[charDataDictionary objectForKey:constants.DAMAGE] intValue]]];
    [defenseValue setText:[NSString stringWithFormat:@"%d", [[charDataDictionary objectForKey:constants.DEFENSE] intValue]]];
    [repairValue setText:[NSString stringWithFormat:@"%d", [[charDataDictionary objectForKey:constants.REPAIR] intValue]]];
    [agilityValue setText:[NSString stringWithFormat:@"%d", [[charDataDictionary objectForKey:constants.AGILITY] intValue]]];
    GameData *gameData = [GameData sharedManager];
    gameData.charClass = [charDataDictionary objectForKey:constants.CLASSNAME];
    gameData.charClassType = charIndex;
}

- (void)chooseCharClass:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    //PlayerData *sharedManager = [PlayerData sharedManager];
    GameData *gameData = [GameData sharedManager];
    confirmAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?"  message:[NSString stringWithFormat:@"You selected the %@ class.", gameData.charClass] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [confirmAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
        NSMutableDictionary *levelDataDict = [charLevelData getLevelDataForLevel:1 andRobotType:[[charDataDictionary objectForKey:constants.CHARCLASSTYPE]intValue]];
        NSLog(@"Yes was selected. levelDataDict : %@", levelDataDict);
        [sldd setCharacterType:[[charDataDictionary objectForKey:constants.CHARCLASSTYPE]intValue]];
        [sldd setAgility:[[charDataDictionary objectForKey:constants.AGILITY]intValue]];
        [sldd setBackgroundImage:[charDataDictionary objectForKey:constants.BACKGROUNDIMAGE]];
        [sldd setClassName:[charDataDictionary objectForKey:constants.CLASSNAME]];
        [sldd setClassDesc:[charDataDictionary objectForKey:constants.CLASSDESC]];
        [sldd setDamage:[[charDataDictionary objectForKey:constants.DAMAGE] intValue]];
        [sldd setDefense:[[charDataDictionary objectForKey:constants.DEFENSE] intValue]];
        [sldd setRepair:[[charDataDictionary objectForKey:constants.REPAIR] intValue]];
        [sldd setRobotImage:[charDataDictionary objectForKey:constants.ROBOTIMAGE]];
        [sldd setCharactersLevel:1];
        [sldd setCurrentExperience:0];
        [sldd playerWinsAgainstOpponentIndex:0];
        [sldd setPlayersCoins:10000];
        [sldd setExperienceToLevel:[[levelDataDict objectForKey:constants.EXPERIENCETOLEVEL] intValue]];
        [sldd setPlayersMaxHitPoints:[[[charClassData getCharClassData:characterIndex] objectForKey:constants.MAXHITPOINTS] intValue]];
        
        PlayerData *playerData = [PlayerData sharedManager];
        [playerData setNewRobotData:charDataDictionary];
        [delegate newCharacterConfirmed];
    }
    else if([title isEqualToString:@"No"])
    {
        NSLog(@"No was selected.");
    }
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
