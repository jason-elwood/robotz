//
//  Constants.m
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "Constants.h"

@implementation Constants

@synthesize AGILITY, BACKGROUNDIMAGE, CLASSDESC, CLASSNAME, DAMAGE, DEFENSE, REPAIR, ROBOTIMAGE, HITPOINTS, CHARCLASSTYPE, PUZZLESTARTINDEX, PLAYERNAME, CURRENTEXPERIENCE, EXPERIENCETOLEVEL, HISCORE, SCORE, TOTALCOINS, PLAYERSLEVEL, EXPERIENCEAWARDED, OPPONENTINDEX, BOOSTIMAGESMALL, BOOSTIMAGELARGE, BOOSTCOST, COINSTAWARDED, MAXHITPOINTS, BOOSTATTACKREWARD, BOOSTDEFENSEREWARD, BOOSTHEALTHREWARD, BOOSTREPAIRREWARD, BOOSTRESURRECTIONREWARD, BOOSTTYPE, MUSICSTARTSCREEN, MUSICBATTLESCREEN, MUSICBATTLELOST, MUSICBATTLEWON, MUSICMAINMENU, MUSICISON, SOUNDFXISON, MESSAGEAWESOME, MESSAGEGREAT, MESSAGENICE, MESSAGENOMOREMATCHES, PURCHASETHREEMILLIONSEVENHUNDREDFIFTYTHOUSANDCOINS, PURCHASEONEMILLIONFIVEHUNDREDTHOUSANDCOINS, PURCHASETHREEHUNDREDTHOUSANDCOINS, PURCHASETWENTYFIVETHOUSANDCOINS, PURCHASETHREERESURRECTIONS, HIDERATEMYAPPFOREVER, NUMBEROFLOGINS, YEAR, MONTH, DAY, BASEAGILITY, BASEATTACK, BASEDEFENSE, BASEREPAIR, OPPONENTINDEXINT, OPPONENTDETAILS, NUMBEROFOPPONENTS, OPPONENTAVATAR, OPPONENTSLEVEL, POINTSFORONESTAR, POINTSFORTHREESTARS, POINTSFORTWOSTARS, NUMBEROFSTARSEARNED, CURRENTPLANET, CURRENTLYPLAYINGMUSIC, PLANETEARTH, PLANETJUPITER, PLANETMARS, PLANETMERCURY, PLANETNEPTUNE, PLANETPLUTO, PLANETSATURN, PLANETURANUS, PLANETVENUS, PLAYERSNAME, RESURRECTIONS;

- (id) init {
    if (self = [super init]) {
        // if init is called directly, just pass nil to AppId contructor variant
        AGILITY = @"agility";
        BACKGROUNDIMAGE = @"backgroundimage";
        CLASSDESC = @"classdesc";
        CLASSNAME = @"classname";
        DAMAGE = @"damage";
        DEFENSE = @"defense";
        REPAIR = @"repair";
        ROBOTIMAGE = @"robotimage";
        HITPOINTS = @"hitpoints";
        MAXHITPOINTS = @"maxhitpoints";
        CHARCLASSTYPE = @"charclasstype";
        PUZZLESTARTINDEX = @"puzzleStartIndex";
        PLAYERNAME = @"playerName";
        EXPERIENCETOLEVEL = @"expToLevel";
        CURRENTEXPERIENCE = @"currentExp";
        HISCORE = @"hiscore";
        SCORE = @"score";
        TOTALCOINS = @"totalcoins";
        PLAYERSLEVEL = @"playerslevel";
        EXPERIENCEAWARDED = @"expawarded";
        OPPONENTINDEX = @"opponentindex";
        BOOSTCOST = @"boostcost";
        BOOSTIMAGELARGE = @"boostimagelarge";
        BOOSTIMAGESMALL = @"boostimagesmall";
        COINSTAWARDED = @"coinsawarded";
        OPPONENTINDEXINT = @"opponentIndexInt";
        BASEREPAIR = [NSNumber numberWithInt:10];
        BASEDEFENSE = [NSNumber numberWithInt:10];
        BASEATTACK = [NSNumber numberWithInt:10];
        BASEAGILITY = [NSNumber numberWithInt:10];
        PLAYERSNAME = @"playersName";
        
        OPPONENTSLEVEL = @"opponentsLevel";
        OPPONENTAVATAR = @"opponentsAvatar";
        POINTSFORONESTAR = @"pointsForOneStar";
        POINTSFORTWOSTARS = @"pointsForTwoStars";
        POINTSFORTHREESTARS = @"pointsForThreeStars";
        NUMBEROFSTARSEARNED = @"numberOfStarsEarned";
        
        NUMBEROFOPPONENTS  = [NSNumber numberWithInt:228];
        
        OPPONENTDETAILS = @"opponentDetails";
        
        BOOSTTYPE = @"boosttype";
        BOOSTATTACKREWARD = @"Greater Attack";
        BOOSTDEFENSEREWARD = @"Greater Defense";
        BOOSTHEALTHREWARD = @"Restore Health";
        BOOSTREPAIRREWARD = @"Greater Agility";
        BOOSTRESURRECTIONREWARD = @"Resurrect Robot";
        
        MUSICSTARTSCREEN = @"Eight_Bit_Space_Battle.mp3";
        MUSICBATTLESCREEN = @"Fluffy_Eight_Bit.mp3";
        MUSICBATTLEWON = @"BattleWon.wav";
        MUSICBATTLELOST = @"BattleLost.wav";
        MUSICMAINMENU = @"Eight_Bit_Space_Battle.mp3";
        MUSICISON = @"musicIsOn";
        SOUNDFXISON = @"soundFxIsOn";
        
        MESSAGEAWESOME = @"awesomeTextPopup.png";
        MESSAGEGREAT = @"greatTextPopup.png";
        MESSAGENICE = @"niceTextPopup.png";
        MESSAGENOMOREMATCHES = @"noMoreMatchesShuffling.png";
        
        PURCHASETWENTYFIVETHOUSANDCOINS = @"25000";
        PURCHASETHREEHUNDREDTHOUSANDCOINS = @"300000";
        PURCHASEONEMILLIONFIVEHUNDREDTHOUSANDCOINS = @"1500000";
        PURCHASETHREEMILLIONSEVENHUNDREDFIFTYTHOUSANDCOINS = @"3750000";
        PURCHASETHREERESURRECTIONS = @"3resurrections";
        
        HIDERATEMYAPPFOREVER = @"hideRateMyAppForever";
        NUMBEROFLOGINS = @"numberOfLogins";
        
        YEAR = @"year";
        MONTH = @"month";
        DAY = @"day";
        
        CURRENTPLANET = @"currentPlanet";
        PLANETVENUS = @"Venus";
        PLANETURANUS = @"Uranus";
        PLANETSATURN = @"Saturn";
        PLANETPLUTO = @"Pluto";
        PLANETNEPTUNE = @"Neptune";
        PLANETMERCURY = @"Mercury";
        PLANETMARS = @"Mars";
        PLANETJUPITER = @"Jupiter";
        PLANETEARTH = @"Earth";
        
        RESURRECTIONS = @"Resurrections";
    }
    return self;
}

@end
