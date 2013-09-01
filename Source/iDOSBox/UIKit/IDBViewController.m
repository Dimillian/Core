//
// iDOSBox
// Copyright (C) 2013  Matthew Vilim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "IDBViewController.h"
#import "IDBModel.h"
#import "SDL_uikitopenglview.h"
#import "QuartzCore/CALayer.h"

@interface IDBViewController ()

@property (readwrite, nonatomic) IDBModel *idbModel;
@property (readwrite, nonatomic) SDL_uikitopenglview *sdlView;
@property (readwrite, nonatomic) BOOL menuVisible;
@property (readwrite, nonatomic) BOOL menuOpen;
@property (readwrite, nonatomic) UIScrollView *scrollView;
@property (readonly, nonatomic) CGSize unscaledSDLViewSize;

@end

@implementation IDBViewController

- (id)initWithIDBModel:(IDBModel *)model andSDLView:(SDL_uikitopenglview *)sdlView {
    if (self = [super init]) {
        _idbModel = model;
        _sdlView = sdlView;
        _menuVisible = NO;
        _menuOpen = NO;
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
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
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
    UIBarButtonItem *keyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardButtonPressed)];
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playButtonPressed)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseButtonPressed)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = [NSArray arrayWithObjects:hideButton, keyboardButton, flexibleSpace, playButton, pauseButton, nil];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHideNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (BOOL)prefersStatusBarHidden {
    return !self.menuVisible;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark Accessors
- (void)setMenuOpen:(BOOL)menuOpen {
    _menuOpen = menuOpen;
    [self setMenuVisible:menuOpen];
    return;
}

- (void)setMenuVisible:(BOOL)menuVisible {
    _menuVisible = menuVisible;
    [self.navigationController setNavigationBarHidden:!self.menuVisible animated:YES];
    [self.navigationController setToolbarHidden:!self.menuVisible animated:YES];
    return;
}

#pragma mark Events
- (void)keyboardWillShowOrHideNotification:(NSNotification *)aNotification {
    // get keyboard values
    CGRect keyboardFrame = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // keyboard orientation is always returned in portrait orientation coordinates, so it must be converted to the local orientation
    CGRect adjustedKeyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    if ([aNotification.name isEqualToString:UIKeyboardWillShowNotification]) {
        // hide navigation and toolbar
        self.menuVisible = NO;
        
        // add content inset to adjust for keyboard appearing
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                           self.scrollView.contentInset.left,
                                                                           self.scrollView.contentInset.bottom + adjustedKeyboardFrame.size.height,
                                                                           self.scrollView.contentInset.right);
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
        // show navigation and toolbar if they were visible before the keyboard was opened
        if (self.menuOpen) {
            self.menuVisible = YES;
        }
        // remove content inset after keyboard dissapears
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                           self.scrollView.contentInset.left,
                                                                           self.scrollView.contentInset.bottom - adjustedKeyboardFrame.size.height,
                                                                           self.scrollView.contentInset.right);
                             self.scrollView.contentInset = contentInsets;
                             self.scrollView.scrollIndicatorInsets = contentInsets;
                         }
                         completion:NULL];
    }
}

- (void)applicationWillResignActiveNotification:(NSNotification *)aNotification {
    self.idbModel.paused = YES;
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if (!self.menuOpen) {
        self.menuOpen = YES;
        self.menuVisible = YES;
    }
    return;
}

- (void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.idbModel.paused) {
        self.idbModel.paused = NO;
    } else if (self.sdlView.keyboardVisible) {
        [self.sdlView hideKeyboard];
    } else if (self.menuOpen) {
        self.menuOpen = NO;
    }
}

- (void)hideButtonPressed {
    self.menuVisible = !self.menuVisible;
    self.menuOpen = !self.menuOpen;
    return;
}

- (void)keyboardButtonPressed {
    [self.sdlView showKeyboard];
    return;
}

- (void)playButtonPressed {
    self.idbModel.paused = NO;
    return;
}

- (void)pauseButtonPressed {
    self.idbModel.paused = YES;
    return;
}

@end