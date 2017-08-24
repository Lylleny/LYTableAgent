//
//  UIViewAdditions.m
//  StrawberryWeekend
//
//  Created by WuZhiping on 15/4/23.
//  Copyright (c) 2015年 GeYeting. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIApplication.h>
#import "SNTableConfiguration.h"

UIInterfaceOrientation SWInterfaceOrientation() {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
        return orient;
}

#ifdef DEBUG_TOUCHES

@interface GSEventFake : NSObject {
@public
    int ignored1[5];
    float x;
    float y;
    int ignored2[24];
}
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation GSEventFake
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIEventFake : NSObject {
@public
    CFTypeRef               _event;
    NSTimeInterval          _timestamp;
    NSMutableSet*           _touches;
    CFMutableDictionaryRef  _keyedTouches;
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIEventFake

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface UITouch (SWCategory)

/**
 *
 */
- (id)initInView:(UIView *)view location:(CGPoint)location;

/**
 *
 */
- (void)changeToPhase:(UITouchPhase)phase;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UITouch (SWCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initInView:(UIView *)view location:(CGPoint)location {
    if (self = [super init]) {
        _tapCount = 1;
        _locationInWindow = location;
        _previousLocationInWindow = location;
        
        UIView *target = [view.window hitTest:_locationInWindow withEvent:nil];
        _view = [target retain];
        _window = [view.window retain];
        _phase = UITouchPhaseBegan;
        _touchFlags._firstTouchForView = 1;
        _touchFlags._isTap = 1;
        _timestamp = [NSDate timeIntervalSinceReferenceDate];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)changeToPhase:(UITouchPhase)phase {
    _phase = phase;
    _timestamp = [NSDate timeIntervalSinceReferenceDate];
}


@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIEvent (SWCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTouch:(UITouch *)touch {
    if (self == [super init]) {
        UIEventFake *selfFake = (UIEventFake*)self;
        selfFake->_touches = [[NSMutableSet setWithObject:touch] retain];
        selfFake->_timestamp = [NSDate timeIntervalSinceReferenceDate];
        
        CGPoint location = [touch locationInView:touch.window];
        GSEventFake* fakeGSEvent = [[GSEventFake alloc] init];
        fakeGSEvent->x = location.x;
        fakeGSEvent->y = location.y;
        selfFake->_event = fakeGSEvent;
        
        CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 2,
                                                                &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionaryAddValue(dict, touch.view, selfFake->_touches);
        CFDictionaryAddValue(dict, touch.window, selfFake->_touches);
        selfFake->_keyedTouches = dict;
    }
    return self;
}


@end

#endif


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
//SW_FIX_CATEGORY_BUG(UIViewAdditions)

#define SW_KEYBOARD_HEIGHT                 ttkDefaultPortraitKeyboardHeight
#define SW_LANDSCAPE_KEYBOARD_HEIGHT       ttkDefaultLandscapeKeyboardHeight
#define SW_IPAD_KEYBOARD_HEIGHT            ttkDefaultPadPortraitKeyboardHeight
#define SW_IPAD_LANDSCAPE_KEYBOARD_HEIGHT  ttkDefaultPadLandscapeKeyboardHeight



const CGFloat ttkDefaultPortraitKeyboardHeight      = 216;
const CGFloat ttkDefaultLandscapeKeyboardHeight     = 160;
const CGFloat ttkDefaultPadPortraitKeyboardHeight   = 264;
const CGFloat ttkDefaultPadLandscapeKeyboardHeight  = 352;
@implementation UIView (SWCategory)

BOOL SWIsKeyboardVisible() {
    // Operates on the assumption that the keyboard is visible if and only if there is a first
    // responder; i.e. a control responding to key events
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    return !![window findFirstResponder];
}
CGFloat SWKeyboardHeight() {
    return SWKeyboardHeightForOrientation(SWInterfaceOrientation());
}
CGFloat SWKeyboardHeightForOrientation(UIInterfaceOrientation orientation) {
    if (SWIsPad()) {
        return UIInterfaceOrientationIsPortrait(orientation) ? SW_IPAD_KEYBOARD_HEIGHT
        : SW_IPAD_LANDSCAPE_KEYBOARD_HEIGHT;
        
    } else {
        return UIInterfaceOrientationIsPortrait(orientation) ? SW_KEYBOARD_HEIGHT
        : SW_LANDSCAPE_KEYBOARD_HEIGHT;
    }
}

BOOL SWIsPad() {
#ifdef __IPHONE_3_2
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}


- (UIView*)findFirstResponder {
    return [self findFirstResponderInView:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape(SWInterfaceOrientation())
    ? self.height : self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape(SWInterfaceOrientation())
    ? self.width : self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


#ifdef DEBUG_TOUCHES

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)simulateTapAtPoint:(CGPoint)location {
    UITouch *touch = [[[UITouch alloc] initInView:self location:location] autorelease];
    
    UIEvent *eventDown = [[[UIEvent alloc] initWithTouch:touch] autorelease];
    [touch.view touchesBegan:[NSSet setWithObject:touch] withEvent:eventDown];
    
    [touch changeToPhase:UITouchPhaseEnded];
    
    UIEvent *eventUp = [[[UIEvent alloc] initWithTouch:touch] autorelease];
    [touch.view touchesEnded:[NSSet setWithObject:touch] withEvent:eventUp];
}

#endif


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)frameWithKeyboardSubtracted:(CGFloat)plusHeight {
    CGRect frame = self.frame;
    if (SWIsKeyboardVisible()) {
        CGRect screenFrame = SCREENRECT;
        CGFloat keyboardTop = (screenFrame.size.height - (SWKeyboardHeight() + plusHeight));
        CGFloat screenBottom = self.ttScreenY + frame.size.height;
        CGFloat diff = screenBottom - keyboardTop;
        if (diff > 0) {
            frame.size.height -= diff;
        }
    }
    return frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)userInfoForKeyboardNotification {
    CGRect screenFrame = SCREENRECT;
    CGRect bounds = CGRectMake(0, 0, screenFrame.size.width, self.height);
    CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                      screenFrame.size.height + floor(self.height/2));
    CGPoint centerEnd = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                    screenFrame.size.height - floor(self.height/2));
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithCGRect:bounds], UIKeyboardBoundsUserInfoKey,
            [NSValue valueWithCGPoint:centerBegin], UIKeyboardCenterBeginUserInfoKey,
            [NSValue valueWithCGPoint:centerEnd], UIKeyboardCenterEndUserInfoKey,
            nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentAsKeyboardAnimationDidStop {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissAsKeyboardAnimationDidStop {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
    [self removeFromSuperview];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentAsKeyboardInView:(UIView*)containingView {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
    
    self.top = containingView.height;
    [containingView addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(presentAsKeyboardAnimationDidStop)];
    self.top -= self.height;
    [UIView commitAnimations];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissAsKeyboard:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAsKeyboardAnimationDidStop)];
    }
    
    self.top += self.height;
    
    if (animated) {
        [UIView commitAnimations];
        
    } else {
        [self dismissAsKeyboardAnimationDidStop];
    }
}

- (void)setRoundCorners:(UIRectCorner)corners cornerRadii:(CGSize)size {
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:size];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}


@end

