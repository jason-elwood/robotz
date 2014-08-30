//
//  CharacterSelectorModule.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerData.h"
#import "GameData.h"

@protocol characterSelectorModuleProtocol <NSObject>

- (void)endTutorial;

@end

@interface CharacterSelectorModule : NSObject<UIScrollViewDelegate> {
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    CGRect rectScrollView;
    CGRect rectPageControl;
    
    int scrollWidth;
    int scrollHeight;
    
    NSArray *contentArray;
    
    UIColor *bcgColor;
    
    BOOL pageControlEnabledTop;
    BOOL pageControlEnabledBottom;
    
    BOOL rememberPosition;
    NSString *positionIdentifier;
    
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (weak) id <characterSelectorModuleProtocol>delegate;

/// returns width of the scollview
- (int)getScrollViewWidth;

/// set width and height for your final UIScrollView
- (void)setWidth:(int)width andHeight:(int)height;

/// set the exactly same size as it is your parent view
- (void)setSizeFromParentView:(UIView *)scView;

/// set background color for your UIScrollView
- (void)setBackGroudColor:(UIColor *)color;

/// set an array with images you want to display in your new scroll view
- (void)setContentArray:(NSArray *)images;

/// display page control for the scroll view on the top of the view (inset)
- (void)enablePageControlOnTop;

/// display page control for the scroll view on the bottom of the view (inset)
- (void)enablePageControlOnBottom;

/// enable position history
- (void)enablePositionMemory;

/// enable position history with custom memory identifier
- (void)enablePositionMemoryWithIdentifier:(NSString *)identifier;

/// returns your UIScrollView with predefined page
- (UIScrollView *)getWithPosition:(int)page;

/// returns your UIScrollView with enabled position history
- (UIScrollView *)getWithPositionMemory;

/// returns your UIScrollView with enabled position history with custom memory identifier
- (UIScrollView *)getWithPositionMemoryIdentifier:(NSString *)identifier;

/// returns your UIScrollView
- (UIScrollView *)get;

@end
