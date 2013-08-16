//
//  IDBViewController.m
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBViewController.h"
#import "SDL_uikitopenglview.h"
#import "SDL_keyboard_c.h"
#import "QuartzCore/CALayer.h"

@interface IDBViewController ()

@property (readwrite, nonatomic) BOOL menuOpen;
@property (readwrite, nonatomic) BOOL paused;
@property (readwrite, nonatomic) UIScrollView *scrollView;
@property (readwrite, nonatomic) SDL_uikitopenglview *sdlView;
@property (readonly, nonatomic) CGSize unscaledSDLViewSize;

@end

@implementation IDBViewController

- (id)initWithSDLView:(SDL_uikitopenglview *)sdlView {
    if (self = [super init]) {
        _menuOpen = NO;
        _paused = NO;
        _sdlView = sdlView;
        _unscaledSDLViewSize = self.sdlView.bounds.size;
    }
    return self;
}

- (void)loadView {
    // don't call [super loadView] because view is created programatically
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.sdlView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.menuOpen = YES;
    
    // setup scroll view
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
    
    // swipe up gesture recognizer
    UISwipeGestureRecognizer *swipeGestureUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureUpRecognizer];
    
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideButtonPressed)];
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playButtonPressed)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseButtonPressed)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = [NSArray arrayWithObjects:hideButton, flexibleSpace, playButton, pauseButton, nil];
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

- (BOOL)prefersStatusBarHidden {
    return !self.menuOpen;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark Accessors
- (void)setMenuOpen:(BOOL)menuOpen {
    _menuOpen = menuOpen;
    [self.navigationController setNavigationBarHidden:!self.menuOpen animated:YES];
    [self.navigationController setToolbarHidden:!self.menuOpen animated:YES];
}

- (void)setPaused:(BOOL)paused {
    if (_paused != paused) {
        SDL_SendKeyboardKey(0, SDL_PRESSED, SDL_SCANCODE_LALT);
        SDL_SendKeyboardKey(0, SDL_PRESSED, SDL_SCANCODE_PAUSE);
        SDL_SendKeyboardKey(0, SDL_RELEASED, SDL_SCANCODE_PAUSE);
        SDL_SendKeyboardKey(0, SDL_RELEASED, SDL_SCANCODE_LALT);
    }
    _paused = paused;
    return;
}

#pragma mark Events
- (void)keyboardWillShowOrHide:(NSNotification *)aNotification {
    // get keyboard values
    CGRect keyboardFrame = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // keyboard orientation is always returned in portrait orientation coordinates, so it must be converted to the local orientation
    CGRect adjustedKeyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    if ([aNotification.name isEqualToString:UIKeyboardWillShowNotification]) {
        self.menuOpen = NO;
        // add content inset to adjust for keyboard appearing
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, adjustedKeyboardFrame.size.height, 0.0f);
                             self.scrollView.contentInset = contentInsets;
                             self.scrollView.scrollIndicatorInsets = contentInsets;
                         }
                         completion:NULL];
        
        // scroll to bottom of scrollview if possible
        if (self.scrollView.bounds.size.height - self.scrollView.contentInset.bottom - self.scrollView.contentInset.top < self.scrollView.contentSize.height) {
            CGPoint contentOffset = CGPointMake(0, self.scrollView.contentSize.height - (self.scrollView.bounds.size.height - adjustedKeyboardFrame.size.height));
            [self.scrollView setContentOffset:contentOffset animated:YES];
        }
    } else if ([aNotification.name isEqualToString:UIKeyboardWillHideNotification]) {
        // remove content inset after keyboard dissapears
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             UIEdgeInsets contentInsets = UIEdgeInsetsZero;
                             self.scrollView.contentInset = contentInsets;
                             self.scrollView.scrollIndicatorInsets = contentInsets;
                         }
                         completion:NULL];
    }
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    self.menuOpen = !self.menuOpen;
    return;
}

- (void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (!self.sdlView.keyboardVisible) {
        [self.sdlView showKeyboard];
    } else {
        [self.sdlView hideKeyboard];
    }
}

#pragma mark
- (void)hideButtonPressed {
    self.menuOpen = !self.menuOpen;
    return;
}

- (void)playButtonPressed {
    self.paused = NO;
    return;
}

- (void)pauseButtonPressed {
    self.paused = YES;
    return;
}

@end