//
//  AANavigationItem.m
//  AANavigationController
//
//  Created by Anton Spivak on 04/10/2017.
//  Copyright © 2017 Anton Spivak. All rights reserved.
//

#import "AANavigationItem.h"
#import "AANavigationPlaceholderView.h"

@implementation AANavigationItem

- (instancetype)init {
    if (self == [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self == [super initWithTitle:title]) {
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
    _aa_needsAppearanceUpdate = YES;
    _aa_needsPushBottomView = NO;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    _aa_needsAppearanceUpdate = YES;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    _aa_needsAppearanceUpdate = YES;
}

- (void)setBottomView:(UIView *)bottomView {
    _bottomView = bottomView;
    _aa_needsPushBottomView = YES;
}

- (void)setOffsetChangeHandeler:(AANavigationItemWillChangeOffsetHandler)offsetChangeHandeler {
    _offsetChangeHandeler = offsetChangeHandeler;
    _aa_needsPushBottomView = YES;
}

@end
