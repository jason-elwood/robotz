//
//  CategoriesAndRobots.h
//  robotz
//
//  Created by Jason Elwood on 10/15/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpponentsDataClass.h"

@interface CategoriesAndRobots : NSObject
{
    OpponentsDataClass *odc;
    
    int currentRobotIndex;
    
    int numCategories;
    NSNumber *numRobotsCategory1;
    NSNumber *numRobotsCategory2;
    NSNumber *numRobotsCategory3;
    NSNumber *numRobotsCategory4;
    NSNumber *numRobotsCategory5;
    NSNumber *numRobotsCategory6;
    NSNumber *numRobotsCategory7;
    NSNumber *numRobotsCategory8;
    NSNumber *numRobotsCategory9;
}

@property (nonatomic, retain) NSMutableDictionary *categoriesAndRobotsDictionary;

@end
