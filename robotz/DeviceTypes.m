//
//  DeviceTypes.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "DeviceTypes.h"
#include <string.h> /* memset */
#include <unistd.h> /* close */

@implementation DeviceTypes

@synthesize deviceHeight, deviceWidth, deviceType;

- (id) init {
    if (self = [super init]) {
        // if init is called directly, just pass nil to AppId contructor variant
        deviceType = [self getModel];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        //NSLog(@"bounds.size.height : %f", [UIScreen mainScreen].bounds.size.height);
        
        deviceWidth = width;
        deviceHeight = height;
        
    }
    return self;
}

- (NSString *)getModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    if ([sDeviceModel isEqual:@"i386"])      return @"Simulator iPhone 5"; deviceWidth = 320; deviceHeight = 568;  //iPhone Simulator
    if ([sDeviceModel isEqual:@"x86_64"])    return @"Simulator iPhone 4"; deviceWidth = 320; deviceHeight = 480;  //iPhone Simulator
    if ([sDeviceModel isEqual:@"iPhone1,1"]) return @"iPhone1G"; deviceWidth = 320; deviceHeight = 480;   //iPhone 1G
    if ([sDeviceModel isEqual:@"iPhone1,2"]) return @"iPhone3G"; deviceWidth = 320; deviceHeight = 480;   //iPhone 3G
    if ([sDeviceModel isEqual:@"iPhone2,1"]) return @"iPhone3GS"; deviceWidth = 320; deviceHeight = 480;  //iPhone 3GS
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"iPhone4 AT&T"; deviceWidth = 320; deviceHeight = 480;  //iPhone 4 - AT&T
    if ([sDeviceModel isEqual:@"iPhone3,2"]) return @"iPhone4 Other"; deviceWidth = 320; deviceHeight = 480;  //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone3,3"]) return @"iPhone4"; deviceWidth = 320; deviceHeight = 480;    //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"iPhone4S"; deviceWidth = 320; deviceHeight = 480;   //iPhone 4S
    if ([sDeviceModel isEqual:@"iPhone5,1"]) return @"iPhone5";    deviceWidth = 320; deviceHeight = 568;//iPhone 5 (GSM)
    if ([sDeviceModel isEqual:@"iPhone5,2"]) return @"iPhone5S";    deviceWidth = 320; deviceHeight = 568;//iPhone 5S (GSM)
    if ([sDeviceModel isEqual:@"iPod1,1"])   return @"iPod1stGen"; //iPod Touch 1G
    if ([sDeviceModel isEqual:@"iPod2,1"])   return @"iPod2ndGen"; //iPod Touch 2G
    if ([sDeviceModel isEqual:@"iPod3,1"])   return @"iPod3rdGen"; //iPod Touch 3G
    if ([sDeviceModel isEqual:@"iPod4,1"])   return @"iPod4thGen"; //iPod Touch 4G
    if ([sDeviceModel isEqual:@"iPad1,1"])   return @"iPadWiFi";   //iPad Wifi
    if ([sDeviceModel isEqual:@"iPad1,2"])   return @"iPad3G";     //iPad 3G
    if ([sDeviceModel isEqual:@"iPad2,1"])   return @"iPad2";      //iPad 2 (WiFi)
    if ([sDeviceModel isEqual:@"iPad2,2"])   return @"iPad2";      //iPad 2 (GSM)
    if ([sDeviceModel isEqual:@"iPad2,3"])   return @"iPad2";      //iPad 2 (CDMA)
    
    
    
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"iPhone4";
            if (version >= 4) return @"iPhone4s";
        
    }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version >=4) return @"iPod4thGen";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version ==1) return @"iPad3G";
        if (version >=2) return @"iPad2";
    }
    //If none was found, send the original string
    return sDeviceModel;
}

@end
