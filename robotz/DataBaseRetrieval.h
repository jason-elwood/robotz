//
//  DataBaseRetrieval.h
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseRetrieval : NSObject
{
    
}

- (void)getPlayerDataFromDatabase;
- (NSString *)getAppURL;
- (NSString *)getFacebookMessage;

@end
