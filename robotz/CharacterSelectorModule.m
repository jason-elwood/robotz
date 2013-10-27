//
//  CharacterSelectorModule.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CharacterSelectorModule.h"



#define kIGUIScrollViewImagePageIdentifier                      @"kIGUIScrollViewImagePageIdentifier"
#define kIGUIScrollViewImageDefaultPageIdentifier               @"Default"

@implementation CharacterSelectorModule

@synthesize scrollView, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (int)getScrollViewWidth {
    return ([contentArray count] * scrollWidth);
}

- (void)setWidth:(int)width andHeight:(int)height {
    scrollWidth = width;
    scrollHeight = height;
    if (!width || !height) rectScrollView = [[UIScreen mainScreen] applicationFrame];
    else rectScrollView = CGRectMake(0, 0, width, height);
}

- (void)setSizeFromParentView:(UIView *)scView {
    scrollWidth = scView.frame.size.width;
    scrollHeight = scView.frame.size.height;
    rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);
}

- (void)setContentArray:(NSArray *)images {
    contentArray = images;
}

- (void)setBackGroudColor:(UIColor *)color {
    bcgColor = color;
}

- (void)enablePageControlOnTop {
    pageControlEnabledTop = YES;
}

- (void)enablePageControlOnBottom {
    pageControlEnabledBottom = YES;
}

- (void)enablePositionMemoryWithIdentifier:(NSString *)identifier {
    rememberPosition = NO;
    if (!identifier) identifier = kIGUIScrollViewImageDefaultPageIdentifier;
    positionIdentifier = identifier;
}

- (void)enablePositionMemory {
    [self enablePositionMemoryWithIdentifier:nil];
}

- (UIScrollView *)getWithPosition:(int)page {
    if (!contentArray) {
        contentArray = [[NSArray alloc] init];
    }
    if (page > [contentArray count]) page = 0;
    
    if (!scrollWidth || !scrollHeight) {
        rectScrollView = [[UIScreen mainScreen] applicationFrame];
        scrollWidth = rectScrollView.size.width;
        scrollHeight = rectScrollView.size.height;
    }
    rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];
    self.scrollView.contentSize = CGSizeMake([self getScrollViewWidth], scrollHeight);
    if (!bcgColor) bcgColor = [UIColor clearColor];
    self.scrollView.backgroundColor = bcgColor;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.contentOffset = CGPointMake(page * scrollWidth, 0);
    self.scrollView.pagingEnabled = YES;
    
    UIView *main = [[UIView alloc] initWithFrame:rectScrollView];
    int i = 0;
    for (UIImage *img in contentArray) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        imageView.backgroundColor = [UIColor clearColor];
        float ratio = img.size.width/rectScrollView.size.width;
        CGRect imageFrame = CGRectMake(i, 0, rectScrollView.size.width, (img.size.height / ratio));
        imageView.frame = imageFrame;
        [self.scrollView addSubview:(UIView *)imageView];
        i += scrollWidth;
    }
    UIImage *bgImage = [UIImage imageNamed:@"background1.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = rectScrollView;
    [main addSubview:bgImageView];
    scrollView.backgroundColor = [UIColor clearColor];
    
    [main addSubview:scrollView];
    if (pageControlEnabledTop) {
        rectPageControl = CGRectMake(0, 5, scrollWidth, 15);
    }
    else if (pageControlEnabledBottom) {
        rectPageControl = CGRectMake(0, (scrollHeight - 25), scrollWidth, 15);
    }
    if (pageControlEnabledTop || pageControlEnabledBottom) {
        pageControl = [[UIPageControl alloc] initWithFrame:rectPageControl];
        pageControl.numberOfPages = [contentArray count];
        pageControl.currentPage = page;
        [main addSubview:pageControl];
    }
    if (pageControlEnabledTop || pageControlEnabledBottom || rememberPosition) self.scrollView.delegate = self;
    //if (margin) [margin release];
    return (UIScrollView *)main;
}

- (UIScrollView *)get {
    return [self getWithPosition:0];
}

- (UIScrollView *)getWithPositionMemory {
    [self enablePositionMemory];
    return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, kIGUIScrollViewImageDefaultPageIdentifier]] intValue]];
}

- (UIScrollView *)getWithPositionMemoryIdentifier:(NSString *)identifier {
    [self enablePositionMemoryWithIdentifier:identifier];
    return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
    int page = sv.contentOffset.x / sv.frame.size.width;
    pageControl.currentPage = page;
    
    PlayerData *sharedPlayerDataManager = [PlayerData sharedManager];
    [sharedPlayerDataManager setCurrentCharacterName:@"Agressor"];
    
    GameData *sharedGameDataManager = [GameData sharedManager];
    [sharedGameDataManager updateCharacterSelectorDetails:page];
    
    if (rememberPosition) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", page] forKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, positionIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
