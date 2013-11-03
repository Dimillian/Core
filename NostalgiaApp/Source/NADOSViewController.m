/*
 * iDOSBox
 * Copyright (C) 2013  Matthew Vilim
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "NADOSViewController.h"
#import "NADOSModel.h"
#import "NADOSView.h"
#import "NGKey.h"

// TESTING ONLY
#import "NGKeyboardKeyView.h"
#import "NGJoystickView.h"

@interface NADOSViewController ()

@property (readwrite, nonatomic) NADOSModel *dosModel;
@property (readwrite, nonatomic) NADOSView *dosView;
@property (readwrite, nonatomic) BOOL menuVisible;
@property (readwrite, nonatomic) BOOL menuOpen;

@end

@implementation NADOSViewController

- (id)initWithIDBModel:(NADOSModel *)dosModel andDOSView:(NADOSView *)dosView {
    if (self = [super init]) {
        _dosView = dosView;
        _dosModel = dosModel;
        _menuVisible = NO;
        _menuOpen = NO;
    }
    return self;
}

- (void)loadView {
    // don't call [super loadView] because view is created programatically
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.dosView];
    
    [self.dosView setFrame:self.view.bounds];
    self.dosView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // TESTING ONLY
    NGKeyboardKeyView *test = [[NGKeyboardKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[NGKey keyWithScancode:SDL_SCANCODE_1]];
    NGJoystickView *test2 = [[NGJoystickView alloc] initWithRadius:60.0f];
    NGKeyboardKeyView *test3 = [[NGKeyboardKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[NGKey keyWithScancode:SDL_SCANCODE_SPACE]];
    NGKeyboardKeyView *test4 = [[NGKeyboardKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[NGKey keyWithScancode:SDL_SCANCODE_3]];
    NGKeyboardKeyView *test5 = [[NGKeyboardKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[NGKey keyWithScancode:SDL_SCANCODE_2]];
    NGKeyboardKeyView *test6 = [[NGKeyboardKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[NGKey keyWithScancode:SDL_SCANCODE_5]];
    [self.dosView addSubview:test];
    [self.dosView addSubview:test2];
    [self.dosView addSubview:test3];
    [self.dosView addSubview:test4];
    [self.dosView addSubview:test5];
    [self.dosView addSubview:test6];
    test.center = CGPointMake(300.0f, 300.0f);
    test2.center = CGPointMake(100.0f, 200.0f);
    test3.center = CGPointMake(300.0f, 500.0f);
    test4.center = CGPointMake(300.0f, 600.0f);
    test5.center = CGPointMake(300.0f, 700.0f);
    test6.center = CGPointMake(300.0f, 800.0f);
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.menuOpen = YES;
    
    // setup scroll view
    self.dosView.contentMode = UIViewContentModeScaleAspectFit;
    
    // swipe up gesture recognizer
    UISwipeGestureRecognizer *swipeGestureUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    swipeGestureUpRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:swipeGestureUpRecognizer];
    
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideButtonPressed)];
    UIBarButtonItem *keyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardButtonPressed)];
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playButtonPressed)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseButtonPressed)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[hideButton, keyboardButton, flexibleSpace, playButton, pauseButton];
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

- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if (!self.menuOpen) {
        self.menuOpen = YES;
        self.menuVisible = YES;
    }
    return;
}

- (void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.dosModel.paused) {
        self.dosModel.paused = NO;
    } else if (self.menuOpen) {
        self.menuOpen = NO;
    }
}

- (void)hideButtonPressed {
    self.menuVisible = !self.menuVisible;
    self.menuOpen = !self.menuOpen;
    return;
}

- (void)playButtonPressed {
    self.dosModel.paused = NO;
    return;
}

- (void)pauseButtonPressed {
    self.dosModel.paused = YES;
    return;
}

@end