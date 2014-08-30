//
//  BoostsData.h
//  robotz
//
//  Created by Jason Elwood on 9/30/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface BoostsData : NSObject
{
    NSMutableDictionary *boostsDataDict;
    Constants *constants;
    
    int boostCost;
    NSString *boostImageSmall;
    NSString *boostImageLarge;
    NSString *boostType;
}

- (NSMutableDictionary *)getBoostsDataForBoostIndex:(int)boostIndex;

@end
