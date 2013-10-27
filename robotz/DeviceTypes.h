//
//  DeviceTypes.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceTypes : NSObject
{
    
}

- (NSString *)getModel;

@property int deviceWidth;
@property int deviceHeight;
@property (atomic, retain) NSString *deviceType;

@end
