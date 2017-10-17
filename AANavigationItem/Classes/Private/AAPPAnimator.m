//
//  AAPPAnimator.m
//  AANavigationController
//
//  Created by Anton Spivak on 04/10/2017.
//  Copyright © 2017 Anton Spivak. All rights reserved.
//

#import "AAPPAnimator.h"
#import <objc/runtime.h>

#import "AANavigationBar.h"

#define AA_ANIMATION_DURATION 0.25f

@implementation AAPPAnimator

+ (void)swizzle {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _UINavigationParallaxTransition = NSClassFromString(@"_UINavigationParallaxTransition");
        SEL animateTransition = NSSelectorFromString(@"animateTransition:");
        Method new_at = class_getInstanceMethod([self class], animateTransition);
        Method old_at = class_getInstanceMethod(_UINavigationParallaxTransition, animateTransition);
        method_exchangeImplementations(old_at, new_at);
    });
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationControllerOperation operation = UINavigationControllerOperationNone;
    SEL _get_operation_sel = NSSelectorFromString(@"operation");
    if ([self respondsToSelector:_get_operation_sel]) {
        IMP _get_operation_imp = [self methodForSelector:_get_operation_sel];
        NSInteger (*_gos_inv)(id, SEL) = (void *)_get_operation_imp;
        operation = _gos_inv(self, _get_operation_sel);
    }
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    BOOL isEqualNavigation = fromViewController.navigationController == toViewController.navigationController;
    BOOL isAANavigationBar = [fromViewController.navigationController.navigationBar isMemberOfClass:[AANavigationBar class]];
    
    if (isEqualNavigation && isAANavigationBar) {
        if (operation == UINavigationControllerOperationPop) {
            [AAPPAnimator performPopOperationWithContext:transitionContext];
        } else {
            [AAPPAnimator performPushOperationWithContext:transitionContext];
        }
    }
    
    SEL aa_at_sel = @selector(animateTransition:);
    IMP aa_at_imp = class_getMethodImplementation([AAPPAnimator class], aa_at_sel);
    typedef void (*aa_at_inv)(id, SEL, id);
    aa_at_inv _aa_at_imp = (aa_at_inv)aa_at_imp;
    _aa_at_imp(self, aa_at_sel, transitionContext);
}

+ (void)performPushOperationWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *toViewController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    AANavigationBar *navigationBar = (AANavigationBar *)toViewController.navigationController.navigationBar;
    
    AANavigationItem *newItem = nil;
    AANavigationItem *oldItem = nil;
    
    if ([[toViewController navigationItem] isKindOfClass:[AANavigationItem class]]) {
        newItem = (AANavigationItem *)toViewController.navigationItem;
    }
    
    if ([[fromViewController navigationItem] isKindOfClass:[AANavigationItem class]]) {
        oldItem = (AANavigationItem *)fromViewController.navigationItem;
    }
    
    [navigationBar prepareNavigationForPushItem:newItem peekItem:oldItem];
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:AA_ANIMATION_DURATION delay:0.0f options:options animations:^{
        [navigationBar animateNavigationForPushItem:newItem peekItem:oldItem];
    } completion:^(BOOL finished) {
        [navigationBar completeNavigationForPushItem:newItem peekItem:oldItem cancelled:[context transitionWasCancelled]];
    }];
}

+ (void)performPopOperationWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *toViewController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    AANavigationBar *navigationBar = (AANavigationBar *)toViewController.navigationController.navigationBar;
    
    AANavigationItem *newItem = nil;
    AANavigationItem *oldItem = nil;
    
    if ([[toViewController navigationItem] isKindOfClass:[AANavigationItem class]]) {
        newItem = (AANavigationItem *)toViewController.navigationItem;
    }
    
    if ([[fromViewController navigationItem] isKindOfClass:[AANavigationItem class]]) {
        oldItem = (AANavigationItem *)fromViewController.navigationItem;
    }
    
    [navigationBar prepareNavigationForPopItem:oldItem peekItem:newItem];
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:AA_ANIMATION_DURATION delay:0.0f options:options animations:^{
        [navigationBar animateNavigationForPopItem:oldItem peekItem:newItem];
    } completion:^(BOOL finished) {
        [navigationBar completeNavigationForPopItem:oldItem peekItem:newItem cancelled:[context transitionWasCancelled]];
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)_customTransitionController:(bool)arg1 {
    SEL _customTransitionController_sel = NSSelectorFromString(@"_customTransitionController:");
    IMP _customTransitionController_imp = class_getMethodImplementation([UINavigationController class],
                                                                        _customTransitionController_sel);

    typedef id (*_customTransitionController)(id, SEL, bool);
    _customTransitionController _ctc_inv = (_customTransitionController)_customTransitionController_imp;
    id _UINavigationParallaxTransition_instance = _ctc_inv(self, _customTransitionController_sel, arg1);

    return _UINavigationParallaxTransition_instance;
}

@end
