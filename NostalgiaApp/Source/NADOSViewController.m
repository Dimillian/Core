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

// TESTING ONLY
#import "NGKeyboardKeyView.h"

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
    NGKeyboardKeyView *test = [[NGKeyboardKeyView alloc] initWithSize:IDBKeyboardKeySize100 andScancode:SDL_SCANCODE_1];
    [self.dosView addSubview:test];
    test.center = CGPointMake(300.0f, 300.0f);
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
    [self.view addGestureRecognizer:swipeGestureUpRecognizer];
    
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideButtonPressed)];
    UIBarButtonItem *keyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardButtonPressed)];
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playButtonPressed)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseButtonPressed)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = [NSArray arrayWithObjects:hideButton, keyboardButton, flexibleSpace, playButton, pauseButton, nil];
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
    [self.dosModel sendKey:SDL_SCANCODE_1 withState:IDBKeyPress];
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