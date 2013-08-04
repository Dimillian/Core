//
//  IDBViewController.m
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBViewController.h"
#import "SDL_uikitopenglview.h"
#import "QuartzCore/CALayer.h"

@interface IDBViewController ()

@property (readwrite, nonatomic) UIScrollView *scrollView;
@property (readwrite, nonatomic) SDL_uikitopenglview *sdlView;
@property (readonly, nonatomic) CGSize unscaledSDLViewSize;

@end

@implementation IDBViewController

- (id)initWithSDLView:(SDL_uikitopenglview *)sdlView {
    if (self = [super init]) {
        _sdlView = sdlView;
        _unscaledSDLViewSize = self.sdlView.bounds.size;
    }
    return self;
}

- (void)loadView {
    // don't call [super loadView] because view is created programatically
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.sdlView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // setup scroll view
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
    
    // swipe up gesture recognizer
    UISwipeGestureRecognizer *swipeGestureUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpGesture:)];
    swipeGestureUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureUpRecognizer];
    // swipe down gesture recognizer
    UISwipeGestureRecognizer *swipeGestureDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGesture:)];
    swipeGestureDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureDownRecognizer];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // scale SDL view to fit screen while maintaing aspect ratio
    CGFloat sdlAspectRatio = self.unscaledSDLViewSize.width / self.unscaledSDLViewSize.height;
    CGFloat viewAspectRatio = self.view.bounds.size.width / self.view.bounds.size.height;
    if (sdlAspectRatio > viewAspectRatio) {
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
    
    // center SDL view horizontally
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
    // UIViewAnimationCurve needs to be converted to UIViewAnimationOptions for animation block
    UIViewAnimationOptions animationOptions;
    switch ((UIViewAnimationCurve)[[aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]) {
        case UIViewAnimationCurveEaseInOut: {
            animationOptions = UIViewAnimationOptionCurveEaseInOut;
        } break;
        case UIViewAnimationCurveEaseIn: {
            animationOptions = UIViewAnimationOptionCurveEaseIn;
        } break;
        case UIViewAnimationCurveEaseOut: {
            animationOptions = UIViewAnimationOptionCurveEaseOut;
        } break;
        case UIViewAnimationCurveLinear: {
            animationOptions = UIViewAnimationOptionCurveLinear;
        } break;
    }
    
    // keyboard orientation is always returned in portrait orientation coordinates, so it must be converted to the local orientation
    CGRect adjustedKeyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
        
    if ([aNotification.name isEqualToString:UIKeyboardWillShowNotification]) {
        // add content inset to adjust for keyboard appearing
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:animationOptions
                         animations:^{
                                    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, adjustedKeyboardFrame.size.height, 0.0f);
                                    self.scrollView.contentInset = contentInsets;
                                    self.scrollView.scrollIndicatorInsets = contentInsets;
                                    }
                         completion:NULL];
        
        // scroll to bottom of scrollview if possible
        if ([self scrollViewCanScroll]) {
            CGPoint contentOffset = CGPointMake(0, self.scrollView.contentSize.height - (self.scrollView.bounds.size.height - adjustedKeyboardFrame.size.height));
            [self.scrollView setContentOffset:contentOffset animated:YES];
        }
    } else if ([aNotification.name isEqualToString:UIKeyboardWillHideNotification]) {
        // remove content inset after keyboard dissapears
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:animationOptions
                         animations:^{
                                    self.scrollView.contentInset = UIEdgeInsetsZero;
                                    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
                                    }
                         completion:NULL];
    }
}

- (BOOL)scrollViewCanScroll {
    return self.scrollView.bounds.size.height - self.scrollView.contentInset.bottom - self.scrollView.contentInset.top < self.scrollView.contentSize.height;
}

#pragma mark Touch Events
- (void)swipeUpGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if (self.navigationController.toolbarHidden) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)swipeDownGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if (!self.navigationController.toolbarHidden) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (!self.sdlView.keyboardVisible) {
        [self.sdlView showKeyboard];
    } else {
        [self.sdlView hideKeyboard];
    }
}

@end