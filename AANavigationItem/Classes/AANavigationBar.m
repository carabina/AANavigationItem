//
//  AANavigationBar.m
//  OKEY
//
//  Created by Anton Spivak on 17/10/2017.
//  Copyright © 2017 Anton Spivak. All rights reserved.
//

#import "AANavigationBar.h"
#import "AAPPAnimator.h"
#import "AANavigationPlaceholderView.h"

#define AA_STATUS_BAR_HEIGHT 20.0f

@implementation AANavigationBar

- (instancetype)init {
    if (self == [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.translucent = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self setShadowImage:[UIImage new]];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.placeholderView = [[AANavigationPlaceholderView alloc] initWithFrame:CGRectZero];
    [self insertSubview:self.placeholderView atIndex:0];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AAPPAnimator swizzle];
    });
}

#pragma - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (![self.topItem isKindOfClass:[AANavigationItem class]]) {
        return;
    }
    
    AANavigationItem *item = (AANavigationItem *)self.topItem;
    if (item.aa_needsPushBottomView) {
        [self setBackgroundColor:item.backgroundColor shadowColor:item.shadowColor];
        item.aa_needsAppearanceUpdate = NO;
    }
    if (item.aa_needsPushBottomView) {
        [self prepareNavigationForPushItem:item peekItem:nil];
        [self animateNavigationForPushItem:item peekItem:nil];
        [self completeNavigationForPushItem:item peekItem:nil cancelled:NO];
        item.aa_needsPushBottomView = NO;
    }
    if (self.placeholderView.bounds.size.width != self.bounds.size.width) {
        [self animateNavigationForPushItem:item peekItem:nil];
        [self animatePlacegolderWithItem:item];
    }
}

#pragma mark - Touches

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint converted = [self convertPoint:point toView:[self placeholderView]];
    if ([[self placeholderView] pointInside:converted withEvent:event] && point.y > [self backgroundView].bounds.size.height) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint converted = [self convertPoint:point toView:[self placeholderView]];
    UIView *view = [[self placeholderView] hitTest:converted withEvent:event];
    if (nil != view  && point.y > [self backgroundView].bounds.size.height) {
        return view;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - Transitions

- (void)prepareNavigationForPushItem:(AANavigationItem *)pushItem peekItem:(AANavigationItem *)peekItem {
    if (nil != pushItem && nil != pushItem.bottomView) {
        [self placeItemBeyondRight:pushItem];
        [self.placeholderView addSubview:pushItem.bottomView];
    }
}

- (void)animateNavigationForPushItem:(AANavigationItem *)pushItem peekItem:(AANavigationItem *)peekItem {
    if (nil != pushItem && nil != pushItem.bottomView) {
        [self placeItemCenter:pushItem];
    }
    if (nil != peekItem && nil != peekItem.bottomView) {
        [self placeItemBeyondLeft:peekItem];
    }
    [self animatePlacegolderWithItem:pushItem];
    
    CGFloat offset = self.placeholderView.bounds.size.height - [self estimatedFrame].size.height;
    if (nil != pushItem && nil != pushItem.offsetChangeHandeler) {
        pushItem.offsetChangeHandeler(offset, NO);
    }
    if (nil != peekItem && nil != peekItem.offsetChangeHandeler) {
        peekItem.offsetChangeHandeler(offset, NO);
    }
}

- (void)completeNavigationForPushItem:(AANavigationItem *)pushItem peekItem:(AANavigationItem *)peekItem cancelled:(BOOL)canceled {
    if (canceled) {
        [self animateNavigationForPushItem:peekItem peekItem:pushItem];
        [self animatePlacegolderWithItem:peekItem];
    } else {
        if (nil != peekItem && nil != peekItem.bottomView) {
            [peekItem.bottomView removeFromSuperview];
        }
    }
}

- (void)prepareNavigationForPopItem:(AANavigationItem *)popItem peekItem:(AANavigationItem *)peekItem {
    if (nil != peekItem && nil != peekItem.bottomView) {
        [self placeItemBeyondLeft:peekItem];
        [self.placeholderView addSubview:peekItem.bottomView];
    }
}

- (void)animateNavigationForPopItem:(AANavigationItem *)popItem peekItem:(AANavigationItem *)peekItem {
    if (nil != popItem && nil != popItem.bottomView) {
        [self placeItemBeyondRight:popItem];
    }
    if (nil != peekItem && nil != peekItem.bottomView) {
        [self placeItemCenter:peekItem];
    }
    [self animatePlacegolderWithItem:peekItem];
    
    
    CGFloat offset = self.placeholderView.bounds.size.height - [self estimatedFrame].size.height;
    if (nil != popItem && nil != popItem.offsetChangeHandeler) {
        popItem.offsetChangeHandeler(offset, NO);
    }
    if (nil != peekItem && nil != peekItem.offsetChangeHandeler) {
        peekItem.offsetChangeHandeler(offset, NO);
    }
}

- (void)completeNavigationForPopItem:(AANavigationItem *)popItem peekItem:(AANavigationItem *)peekItem cancelled:(BOOL)canceled {
    if (canceled) {
        [self animateNavigationForPopItem:peekItem peekItem:popItem];
        [self animatePlacegolderWithItem:popItem];
    } else {
        if (nil != popItem && nil != popItem.bottomView) {
            [popItem.bottomView removeFromSuperview];
        }
    }
}

#pragma mark - Common

- (void)animatePlacegolderWithItem:(AANavigationItem *)item {
    CGRect frame = [self estimatedFrame];
    if (nil != item && nil != item.bottomView) {
        frame.size.height += item.bottomView.bounds.size.height;
    }
    
    self.placeholderView.frame = frame;
    [self setBackgroundColor:item.backgroundColor shadowColor:item.shadowColor];
    [self.placeholderView updateBorderIfNeeded];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor shadowColor:(UIColor *)shadowColor {
    UIColor *bColor = [backgroundColor copy];
    if (nil == bColor) {
        bColor = self.barTintColor;
    }
    if (nil == bColor) {
        bColor = [UIColor lightGrayColor];
    }
    
    UIColor *sColor = [shadowColor copy];
    if (nil == sColor) {
        sColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    }
    
    self.placeholderView.backgroundColor = bColor;
    self.placeholderView.bottomBorderView.backgroundColor = sColor;
}

- (void)placeItemBeyondRight:(AANavigationItem *)item {
    item.bottomView.alpha = -1.0f;
    item.bottomView.frame = (CGRect){self.bounds.size.width/2, [self estimatedFrame].size.height, item.bottomView.bounds.size};
}

- (void)placeItemBeyondLeft:(AANavigationItem *)item {
    item.bottomView.alpha = -1.0f;
    item.bottomView.frame = (CGRect){-self.bounds.size.width/2, 0.0f, item.bottomView.bounds.size};
}

- (void)placeItemCenter:(AANavigationItem *)item {
    item.bottomView.alpha = 1.0f;
    item.bottomView.frame = (CGRect){(self.bounds.size.width - item.bottomView.bounds.size.width)/2, [self estimatedFrame].size.height, item.bottomView.bounds.size};
}

#pragma mark - Helpers

- (CGRect)estimatedFrame {
    CGRect frame = self.frame;
    if (frame.size.width == 0.0f) {
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
    }
    if (frame.origin.y > 0.0f) {
        frame.size.height += frame.origin.y;
        frame.origin.y = -frame.origin.y;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (frame.origin.y == 0.0f && UIInterfaceOrientationIsPortrait(orientation)) {
        frame.origin.y -= AA_STATUS_BAR_HEIGHT;
        frame.size.height += AA_STATUS_BAR_HEIGHT;
    }
    
    return frame;
}

#pragma mark - Setters & Getters

- (UIView *)backgroundView {
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
            return subview;
        }
    }
    return nil;
}

@end
