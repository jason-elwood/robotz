//
//  AnimationsClass.h
//  robotz
//
//  Created by Jason Elwood on 9/19/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "EncouragingWords.h"
#import "DeviceTypes.h"

@protocol AnimationsClassBoostsProtocol <NSObject>

- (void)boostsAnimationFinished;

@end

@protocol AnimationsClassProtocol <NSObject>

- (void)pieceAnimationFinished;

@end

@interface AnimationsClass : NSObject
{
    DeviceTypes *deviceTypes;
    int pieceDistanceCheck;
    int acceleration;
    int shakeDistance;
    int shakeStopXpos;
    int currentShakeXpos;
    
    BOOL imageIsTransparent;
    BOOL fadingIn;
    BOOL fadingOut;
    
    NSTimer *button1Timer;
    NSTimer *button2Timer;
    NSTimer *button3Timer;
    NSTimer *button4Timer;
    NSTimer *button5Timer;
    
    NSTimer *encourageTextTimer;
    
    NSDate *button1Date;
    NSDate *button2Date;
    NSDate *button3Date;
    NSDate *button4Date;
    NSDate *button5Date;
    
    NSRunLoop *button1Loop;
    NSRunLoop *button2Loop;
    NSRunLoop *button3Loop;
    NSRunLoop *button4Loop;
    NSRunLoop *button5Loop;
}

@property (weak) id delegate;

- (void)animateYaxisPiece:(Piece *)piece;
- (void)animateUIViewYaxisShow:(UIView *)view;
- (void)animateUIViewYaxisHide:(UIView *)view;
- (void)shake:(UIView *)view;
- (void)fireball:(UIView *)view startPos:(CGPoint)start endPos:(CGPoint)end duration:(float)duration;
- (void)animatePointBurst:(UIView *)burst;
- (void)animateXaxisImageViewsLayer:(CALayer *)layer from:(float)from to:(float)to duration:(float)duration repeat:(int)repeat;
- (void)animateAlphaImageViewsLayer:(CALayer *)layer from:(float)from to:(float)to duration:(float)duration repeat:(int)repeat;
- (void)animateButtonBackground:(UIImageView *)buttonBG withButtonIndex:(int)index;
- (void)stopAnimatingButtonBackground:(UIImageView *)buttonBG withButtonIndex:(int)index;
- (void)animateEncouragingText:(EncouragingWords *)message;
- (void)fadeInView:(UIView *)message;
- (void)fadeOutView:(UIView *)message;
   
@end
