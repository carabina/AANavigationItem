//
//  AANavigationItem.h
//  AANavigationController
//
//  Created by Anton Spivak on 04/10/2017.
//  Copyright © 2017 Anton Spivak. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AANavigationItemWillChangeOffsetHandler)(CGFloat offset, BOOL animated);

@interface AANavigationItem : UINavigationItem

@property (strong, nonatomic) IBInspectable UIColor *backgroundColor;
@property (strong, nonatomic) IBInspectable UIColor *shadowColor;

@property (nonatomic) BOOL aa_needsAppearanceUpdate;
@property (nonatomic) BOOL aa_needsPushBottomView;

@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic) AANavigationItemWillChangeOffsetHandler offsetChangeHandeler;

@end
