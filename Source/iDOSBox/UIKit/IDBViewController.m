//
//  IDBViewController.m
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBViewController.h"
#import "SDL_uikitview.h"
#import "QuartzCore/CALayer.h"

@interface IDBViewController ()

@property (readwrite, nonatomic) UIScrollView *scrollView;
@property (readwrite, nonatomic) SDL_uikitview *sdlView;
@property (readonly, nonatomic) CGSize unscaledSDLViewSize;

@end

@implementation IDBViewController

- (id)initWithSDLView:(SDL_uikitview *)sdlView {
    if (self = [super init]) {
        _sdlView = sdlView;
        _unscaledSDLViewSize = sdlView.bounds.size;
    }
    return self;
}

- (void)loadView {
    // don't call [super loadView] because view is created programatically
    
    // setup view
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    // setup scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.scrollView addSubview:self.sdlView];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.sdlView addGestureRecognizer:singleTapRecognizer];
    
    [self.view addSubview:self.scrollView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // scale SDL view to fit screen while maintaing aspect ratio
    CGFloat sdlAspectRatio = self.unscaledSDLViewSize.width / self.unscaledSDLViewSize.height;
    CGFloat screenAspectRatio = self.view.bounds.size.width / self.view.bounds.size.height;
    if (sdlAspectRatio > screenAspectRatio) {
        self.sdlView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.width / sdlAspectRatio);
    } else {
        self.sdlView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.height * sdlAspectRatio, self.view.bounds.size.height);
    }
    
    // if SDL view is enlarged, change magnification filter
    if (self.sdlView.bounds.size.width > self.unscaledSDLViewSize.width && self.sdlView.bounds.size.height > self.unscaledSDLViewSize.height) {
        self.sdlView.layer.magnificationFilter = kCAFilterNearest;
    } else {
        self.sdlView.layer.magnificationFilter = kCAFilterLinear;
    }
    
    // center horizontally
    self.sdlView.center = CGPointMake(self.scrollView.center.x, self.sdlView.center.y);
    
    // adjust scroll view content size
    self.scrollView.contentSize = self.sdlView.bounds.size;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShowOrHide:(NSNotification *)aNotification {
    // get keyboard values
    CGRect keyboardFrame = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    // keyboard orientation is always returned in portrait orientation coordinates, so it must be converted to the local orientation
    CGRect adjustedKeyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
        
    if ([aNotification.name isEqualToString:UIKeyboardWillShowNotification]) {        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, adjustedKeyboardFrame.size.height, 0.0f);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        [UIView commitAnimations];
        
        // scroll to bottom
        CGPoint contentOffset = CGPointMake(0, self.scrollView.contentSize.height - (self.scrollView.bounds.size.height - adjustedKeyboardFrame.size.height));
        [self.scrollView setContentOffset:contentOffset animated:YES];
    } else if ([aNotification.name isEqualToString:UIKeyboardWillHideNotification]) {        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
        
        [UIView commitAnimations];
    }
}

- (void)singleTap {
    if (!self.sdlView.keyboardVisible) {
        [self.sdlView showKeyboard];
    } else {
        [self.sdlView hideKeyboard];
    }
}

@end