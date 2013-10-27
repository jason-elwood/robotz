//
//  Constants.h
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
{
    
}

@property (readonly) NSString *CHARCLASSTYPE;
@property (readonly) NSString *CLASSNAME;
@property (readonly) NSString *CLASSDESC;
@property (readonly) NSString *BACKGROUNDIMAGE;
@property (readonly) NSString *ROBOTIMAGE;
@property (readonly) NSString *DAMAGE;
@property (readonly) NSString *DEFENSE;
@property (readonly) NSString *REPAIR;
@property (readonly) NSString *AGILITY;
@property (readonly) NSString *HITPOINTS;
@property (readonly) NSString *PUZZLESTARTINDEX;
@property (readonly) NSString *PLAYERNAME;
@property (readonly) NSString *EXPERIENCETOLEVEL;
@property (readonly) NSString *CURRENTEXPERIENCE;
@property (readonly) NSString *SCORE;
@property (readonly) NSString *HISCORE;
@property (readonly) NSString *TOTALCOINS;
@property (readonly) NSString *PLAYERSLEVEL;
@property (readonly) NSString *EXPERIENCEAWARDED;
@property (readonly) NSString *COINSTAWARDED;
@property (readonly) NSString *OPPONENTINDEX;
@property (readonly) NSString *BOOSTCOST;
@property (readonly) NSString *BOOSTIMAGESMALL;
@property (readonly) NSString *BOOSTIMAGELARGE;
@property (readonly) NSString *MAXHITPOINTS;
@property (readonly) NSString *OPPONENTINDEXINT;
@property (readonly) NSString *PLAYERSNAME;

@property (readonly) NSNumber *NUMBEROFOPPONENTS;

@property (readonly) NSString *OPPONENTDETAILS;

@property (readonly) NSNumber *BASEATTACK;
@property (readonly) NSNumber *BASEDEFENSE;
@property (readonly) NSNumber *BASEREPAIR;
@property (readonly) NSNumber *BASEAGILITY;

// boost constants
@property (readonly) NSString *BOOSTTYPE;
@property (readonly) NSString *BOOSTHEALTHREWARD;
@property (readonly) NSString *BOOSTATTACKREWARD;
@property (readonly) NSString *BOOSTDEFENSEREWARD;
@property (readonly) NSString *BOOSTREPAIRREWARD;
@property (readonly) NSString *BOOSTRESURRECTIONREWARD;

// music and sounds constants
@property (readonly) NSString *MUSICSTARTSCREEN;
@property (readonly) NSString *MUSICBATTLESCREEN;
@property (readonly) NSString *MUSICBATTLEWON;
@property (readonly) NSString *MUSICBATTLELOST;
@property (readonly) NSString *MUSICMAINMENU;
@property (readonly) NSString *MUSICISON;
@property (readonly) NSString *SOUNDFXISON;

@property NSString *CURRENTLYPLAYINGMUSIC;

// encouraging messages constants
@property (readonly) NSString *MESSAGEGREAT;
@property (readonly) NSString *MESSAGEAWESOME;
@property (readonly) NSString *MESSAGENICE;
@property (readonly) NSString *MESSAGENOMOREMATCHES;

// in app purchase constatnts
@property (readonly) NSString *PURCHASETWENTYFIVETHOUSANDCOINS;
@property (readonly) NSString *PURCHASETHREEHUNDREDTHOUSANDCOINS;
@property (readonly) NSString *PURCHASEONEMILLIONFIVEHUNDREDTHOUSANDCOINS;
@property (readonly) NSString *PURCHASETHREEMILLIONSEVENHUNDREDFIFTYTHOUSANDCOINS;
@property (readonly) NSString *PURCHASETHREERESURRECTIONS;

@property (readonly) NSString *HIDERATEMYAPPFOREVER;
@property (readonly) NSString *NUMBEROFLOGINS;

// date constants
@property (readonly) NSString *YEAR;
@property (readonly) NSString *MONTH;
@property (readonly) NSString *DAY;

@property (readonly) NSString *OPPONENTAVATAR;
@property (readonly) NSString *OPPONENTSLEVEL;
@property (readonly) NSString *POINTSFORONESTAR;
@property (readonly) NSString *POINTSFORTWOSTARS;
@property (readonly) NSString *POINTSFORTHREESTARS;
@property (readonly) NSString *NUMBEROFSTARSEARNED;

@property (readonly) NSString *CURRENTPLANET;
@property (readonly) NSString *PLANETMERCURY;
@property (readonly) NSString *PLANETVENUS;
@property (readonly) NSString *PLANETEARTH;
@property (readonly) NSString *PLANETMARS;
@property (readonly) NSString *PLANETJUPITER;
@property (readonly) NSString *PLANETSATURN;
@property (readonly) NSString *PLANETURANUS;
@property (readonly) NSString *PLANETNEPTUNE;
@property (readonly) NSString *PLANETPLUTO;

@property (readonly)NSString *RESURRECTIONS;

@end
