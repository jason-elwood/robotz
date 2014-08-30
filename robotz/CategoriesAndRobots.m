//
//  CategoriesAndRobots.m
//  robotz
//
//  Created by Jason Elwood on 10/15/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CategoriesAndRobots.h"

@implementation CategoriesAndRobots

@synthesize categoriesAndRobotsDictionary;

- (id)init
{
    self = [super init];
    if (self) {
        categoriesAndRobotsDictionary = [[NSMutableDictionary alloc] init];
        currentRobotIndex = 1;
        odc = [[OpponentsDataClass alloc] init];
        numCategories = 9;
        numRobotsCategory1 = [NSNumber numberWithInt:2];
        numRobotsCategory2 = [NSNumber numberWithInt:4];
        numRobotsCategory3 = [NSNumber numberWithInt:8];
        numRobotsCategory4 = [NSNumber numberWithInt:10];
        numRobotsCategory5 = [NSNumber numberWithInt:16];
        numRobotsCategory6 = [NSNumber numberWithInt:20];
        numRobotsCategory7 = [NSNumber numberWithInt:40];
        numRobotsCategory8 = [NSNumber numberWithInt:64];
        numRobotsCategory9 = [NSNumber numberWithInt:63];
        [self buildDataDictionary];
    }
    return self;
}

- (void)buildDataDictionary
{
    NSMutableArray *numRobotsArray = [[NSMutableArray alloc] initWithObjects:numRobotsCategory1, numRobotsCategory2, numRobotsCategory3, numRobotsCategory4, numRobotsCategory5, numRobotsCategory6, numRobotsCategory7, numRobotsCategory8,numRobotsCategory9, nil];
    
    NSMutableArray *categoriesArray = [[NSMutableArray alloc] initWithObjects:@"Mercury", @"Venus", @"Earth", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto",  nil];
    
    NSMutableArray *robotDictionaries = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init], nil];
    
    for (int i = 0; i < numCategories; i++) {
        [categoriesAndRobotsDictionary setObject:[robotDictionaries objectAtIndex:i] forKey:[categoriesArray objectAtIndex:i]];
        for (int j = 0; j < [[numRobotsArray objectAtIndex:i] intValue]; j++) {
            if ([odc getOpponentData:currentRobotIndex] == NULL) {
                currentRobotIndex++;
                return;
            }
            [(NSMutableArray *)[robotDictionaries objectAtIndex:i] addObject:[odc getOpponentData:currentRobotIndex]];
            currentRobotIndex++;
        }
        [categoriesAndRobotsDictionary setObject:[robotDictionaries objectAtIndex:i] forKey:[categoriesArray objectAtIndex:i]];
    }
}

@end
