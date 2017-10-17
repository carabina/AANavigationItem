//
//  AANavigationPlaceholderView.h
//  AANavigationController
//
//  Created by Anton Spivak on 04/10/2017.
//  Copyright © 2017 Anton Spivak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AANavigationPlaceholderView : UIView

@property (strong, nonatomic) UIView *bottomBorderView;
@property (strong, nonatomic) UIView *bottomCustomView;

- (void)updateBorderIfNeeded;

@end
