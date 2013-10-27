//
//  DataBaseRetrieval.m
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "DataBaseRetrieval.h"

@implementation DataBaseRetrieval

- (void)getPlayerDataFromDatabase
{
    NSURL* URL=[NSURL URLWithString: @"http://www.simplexitycubed.com/test.php"];
    NSURLRequest* req=[NSURLRequest requestWithURL: URL];
    NSData* data=[NSURLConnection sendSynchronousRequest: req returningResponse: nil error: nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Data: %@", json);
}

- (NSString *)getAppURL
{
    NSURL* URL=[NSURL URLWithString: @"http://droppedpixelgames.com/appURL.php"];
    NSURLRequest* req=[NSURLRequest requestWithURL: URL];
    NSData* data=[NSURLConnection sendSynchronousRequest: req returningResponse: nil error: nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Data: %@", json);
    return  json;
}

@end
