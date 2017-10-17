//
//  AANavigationPlaceholderView.m
//  AANavigationController
//
//  Created by Anton Spivak on 04/10/2017.
//  Copyright © 2017 Anton Spivak. All rights reserved.
//

#import "AANavigationPlaceholderView.h"

@implementation AANavigationPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.bottomBorderView];
    }
    return self;
}

- (void)updateBorderIfNeeded {
    CGRect frame = self.bounds;
    frame.origin.y = frame.size.height - 0.5f;
    frame.size.height = 0.5f;
    self.bottomBorderView.frame = frame;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view == self ? nil : view;
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    [self bringSubviewToFront:self.bottomBorderView];
}

@end
