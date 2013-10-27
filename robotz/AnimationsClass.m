//
//  AnimationsClass.m
//  robotz
//
//  Created by Jason Elwood on 9/19/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "AnimationsClass.h"

@implementation AnimationsClass

@synthesize delegate;

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

- (id)init
{
    self = [super init];
    if (self) {
        deviceTypes = [[DeviceTypes alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"MyNotification" object:nil];
        imageIsTransparent = NO;
    }
    return self;
}

- (void)fadeInView:(UIView *)message
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *noMoreMovesTextTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(fadeIn:) userInfo:message repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: noMoreMovesTextTimer forMode: NSDefaultRunLoopMode];
}


- (void)fadeOutView:(UIView *)message
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *noMoreMovesTextTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(fadeOut:) userInfo:message repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: noMoreMovesTextTimer forMode: NSDefaultRunLoopMode];
}

- (void)fadeIn:(NSTimer *)timer
{
    UIImageView *view = [timer userInfo];
    if (view.alpha > 1.0) {
        view.alpha = 1.0;
        [timer invalidate];
        timer = nil;
    }
    view.alpha += 0.05;
}

- (void)fadeOut:(NSTimer *)timer
{
    UIImageView *view = [timer userInfo];
    if (view.alpha < 0.0) {
        view.alpha = 0.0;
        [timer invalidate];
        timer = nil;
        [view removeFromSuperview];
        view = nil;
    }
    view.alpha -= 0.05;
}


- (void)animateEncouragingText:(EncouragingWords *)message
{
    fadingIn = YES;
    fadingOut = NO;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    encourageTextTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(encouragingTextAnimation:) userInfo:message repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: encourageTextTimer forMode: NSDefaultRunLoopMode];
}

- (void)encouragingTextAnimation:(NSTimer *)timer
{
    EncouragingWords *ew = [timer userInfo];
    ew.frame = CGRectMake(ew.frame.origin.x, ew.frame.origin.y - 1, ew.frame.size.width, ew.frame.size.height);
    if (fadingIn) {
        ew.alpha += 0.02;
    }
    if (ew.alpha >= 1.0) {
        fadingIn = NO;
        fadingOut = YES;
    }
    if (fadingOut) {
        ew.alpha -= 0.02;
    }
    if (ew.alpha <= 0.0) {
        [encourageTextTimer invalidate];
        encourageTextTimer = nil;
        [ew removeFromSuperview];
    }
    
}

- (void)animateButtonBackground:(UIImageView *)buttonBG withButtonIndex:(int)index
{
    if (index == 0) {
        button1Date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
        button1Timer = [[NSTimer alloc] initWithFireDate:button1Date interval:0.05 target:self selector:@selector(flashButtonBG:) userInfo:buttonBG repeats:YES];
        button1Loop = [NSRunLoop currentRunLoop];
        [button1Loop addTimer: button1Timer forMode: NSDefaultRunLoopMode];
    } else if (index == 1) {
        button2Date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
        button2Timer = [[NSTimer alloc] initWithFireDate:button2Date interval:0.05 target:self selector:@selector(flashButtonBG:) userInfo:buttonBG repeats:YES];
        button2Loop = [NSRunLoop currentRunLoop];
        [button2Loop addTimer: button2Timer forMode: NSDefaultRunLoopMode];
    }
    
}

- (void)flashButtonBG:(NSTimer *)timer
{
    UIImageView *buttonBG = (UIImageView *)[timer userInfo];
    if (!imageIsTransparent) {
        buttonBG.alpha -= 0.05;
        if (buttonBG.alpha <= 0.0) {
            imageIsTransparent = YES;
        }
    } else {
        buttonBG.alpha += 0.05;
        if (buttonBG.alpha >= 1.0) {
            imageIsTransparent = NO;
        }
    }
}

- (void)stopAnimatingButtonBackground:(UIImageView *)buttonBG withButtonIndex:(int)index
{
    buttonBG.alpha = 0.1;
    if (index == 0) {
        [button1Timer invalidate];
        button1Timer = nil;
    } else if (index == 1) {
        [button2Timer invalidate];
        button2Timer = nil;
    }
}

- (void)animatePointBurst:(UIView *)burst
{
    CABasicAnimation *rise = [CABasicAnimation animationWithKeyPath:@"position"];
    [rise setDuration:1.5];
    [rise setFromValue:[NSValue valueWithCGPoint:
                        CGPointMake(burst.center.x, burst.center.y)]];
    [rise setToValue:[NSValue valueWithCGPoint:
                      CGPointMake(burst.center.x, burst.center.y - 20)]];
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setDuration:1.5];
    fade.fromValue = [NSNumber numberWithFloat:1.0];
    fade.toValue = [NSNumber numberWithFloat:0.0];
    
    [burst.layer addAnimation:fade forKey:@"opacity"];
    [burst.layer addAnimation:rise forKey:@"position"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 1.0];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(removeViewFromSuperView:) userInfo:burst repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}

- (void)removeViewFromSuperView:(NSTimer *)timer
{
    
    [[timer userInfo] removeFromSuperview];
    [timer invalidate];
    timer = nil;
    
}

- (void)shake:(UIView *)view
{
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(view.center.x - 5,view.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(view.center.x + 5, view.center.y)]];
    [view.layer addAnimation:shake forKey:@"position"];
}

- (void)fireball:(UIView *)view startPos:(CGPoint)start endPos:(CGPoint)end duration:(float)duration
{
    int fromX = start.x;
    int fromY = start.y;
    int toX = end.x;
    int toY = end.y;
    
    NSString *keyPathX = @"transform.translation.x";
    CAKeyframeAnimation *translationX = [CAKeyframeAnimation animationWithKeyPath:keyPathX];
    translationX.duration = duration;
    NSMutableArray *valuesX = [[NSMutableArray alloc] init];
    [valuesX addObject:[NSNumber numberWithFloat:fromX]];
    [valuesX addObject:[NSNumber numberWithFloat:toX]];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    translationX.values = valuesX;
    
    NSString *keyPathY = @"transform.translation.y";
    CAKeyframeAnimation *translationY = [CAKeyframeAnimation animationWithKeyPath:keyPathY];
    translationY.duration = duration;
    NSMutableArray *valuesY = [[NSMutableArray alloc] init];
    [valuesY addObject:[NSNumber numberWithFloat:fromY]];
    [valuesY addObject:[NSNumber numberWithFloat:toY]];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    translationY.values = valuesY;
    
    [view.layer addAnimation:translationX forKey:keyPathX];
    [view.layer addAnimation:translationY forKey:keyPathY];
}

- (void)wobble:(UIView *)view
{
    
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-15.0));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(15.0));
    
    view.transform = leftWobble;  // starting point
    
    [UIView beginAnimations:@"wobble" context:(__bridge void *)(view)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:5]; // adjustable
    [UIView setAnimationDuration:0.125];
    [UIView setAnimationDelegate:self];
    view.transform = rightWobble; // end here & auto-reverse
    [UIView commitAnimations];
}

- (void)animateUIViewYaxisShow:(UIView *)view
{
    // Start load screen title timer.
    acceleration = 0;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(animateUIViewDown:) userInfo:view repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}

- (void)animateUIViewDown:(NSTimer *)timer
{
    UIView *view = [timer userInfo];
    acceleration += 2;
    
    view.frame = CGRectMake(0, view.frame.origin.y + acceleration, view.frame.size.width, view.frame.size.height);
    if (view.frame.origin.y >= 0 - acceleration) {
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [timer invalidate];
        timer = nil;
    }
}

- (void)animateUIViewYaxisHide:(UIView *)view
{
    // Start load screen title timer.
    acceleration = 0;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(animateUIViewUp:) userInfo:view repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}

- (void)animateUIViewUp:(NSTimer *)timer
{
    UIView *view = [timer userInfo];
    acceleration -= 2;
    
    view.frame = CGRectMake(0, view.frame.origin.y + acceleration, view.frame.size.width, view.frame.size.height);
    if (view.frame.origin.y <= -deviceTypes.deviceHeight) {
        [timer invalidate];
        timer = nil;
        [delegate boostsAnimationFinished];
    }
}

- (void)animateYaxisPiece:(Piece *)piece
{
    // Start load screen title timer.
    pieceDistanceCheck = 53;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(animatePiece:) userInfo:piece repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}

- (void)animatePiece:(NSTimer *)timer
{
    ((Piece *)[timer userInfo]).frame = CGRectMake(((Piece *)[timer userInfo]).frame.origin.x, ((Piece *)[timer userInfo]).frame.origin.y + 1, 53, 53);
    pieceDistanceCheck--;
    if (pieceDistanceCheck == 0) {
        [timer invalidate];
        timer = nil;
        [self animationFinished];
    }
}

- (void)animationFinished
{
    [delegate pieceAnimationFinished];
}

- (void)animateXaxisImageViewsLayer:(CALayer *)layer from:(float)from to:(float)to duration:(float)duration repeat:(int)repeat
{
    // The keyPath to animate
    NSString *keyPath = @"transform.translation.x";
    
    // Allocate a CAKeyFrameAnimation for the specified keyPath.
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    // Set animation duration and repeat
    translation.duration = duration;
    translation.repeatCount = repeat;
    
    // Allocate array to hold the values to interpolate
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    // Add the start value
    // The animation starts at a y offset of 0.0
    [values addObject:[NSNumber numberWithFloat:from]];
    
    // Add the end value
    [values addObject:[NSNumber numberWithFloat:to]];
    
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // Set the values that should be interpolated during the animation
    translation.values = values;
    
    [layer addAnimation:translation forKey:keyPath];
}

- (void)animateAlphaImageViewsLayer:(CALayer *)layer from:(float)from to:(float)to duration:(float)duration repeat:(int)repeat
{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:from];
    alphaAnimation.toValue = [NSNumber numberWithFloat:to];
    alphaAnimation.duration = duration;
    
    [layer addAnimation:alphaAnimation forKey:nil];
}

@end
