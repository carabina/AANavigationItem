//
//  AANavigationBar.h
//  OKEY
//
//  Created by Anton Spivak on 17/10/2017.
//  Copyright © 2017 Anton Spivak. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AANavigationItem.h"

@class AANavigationPlaceholderView;

@interface AANavigationBar : UINavigationBar

@property (strong, nonatomic) AANavigationPlaceholderView *placeholderView;
@property (strong, nonatomic, readonly) UIView *backgroundView;

- (void)prepareNavigationForPushItem:(AANavigationItem *)pushItem peekItem:(AANavigationItem *)peekItem;
- (void)animateNavigationForPushItem:(AANavigationItem *)pushItem peekItem:(AANavigationItem *)peekItem;
- (void)completeNavigationForPushItem:(AANavigationItem *)pushItem peekItem:(AANavigationItem *)peekItem cancelled:(BOOL)canceled;

- (void)prepareNavigationForPopItem:(AANavigationItem *)popItem peekItem:(AANavigationItem *)peekItem;
- (void)animateNavigationForPopItem:(AANavigationItem *)popItem peekItem:(AANavigationItem *)peekItem;
- (void)completeNavigationForPopItem:(AANavigationItem *)popItem peekItem:(AANavigationItem *)peekItem cancelled:(BOOL)canceled;

@end
