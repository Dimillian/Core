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

#import "IDBViewController.h"
#import "IDBModel.h"
#import "IDBView.h"
#import "SDL_uikitopenglview.h"

@interface IDBViewController ()

@property (readwrite, nonatomic) IDBModel *idbModel;
@property (readwrite, nonatomic) IDBView *idbview;
@property (readwrite, nonatomic) BOOL menuVisible;
@property (readwrite, nonatomic) BOOL menuOpen;

@end

@implementation IDBViewController

- (id)initWithIDBModel:(IDBModel *)model andSDLView:(IDBView *)idbView {
    if (self = [super init]) {
        _idbView = idbView;
        _idbModel = model;
        _menuVisible = NO;
        _menuOpen = NO;
    }
    return self;
}

- (void)loadView {
    // don't call [super loadView] because view is created programatically
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.idbView];
    
    [self.idbView setFrame:self.view.bounds];
    self.idbView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.menuOpen = YES;
    
    // setup scroll view
    self.idbView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    [IDBModel sendKey:SDL_SCANCODE_1 withState:IDBKeyPress];
    if (self.idbModel.paused) {
        self.idbModel.paused = NO;
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
    self.idbModel.paused = NO;
    return;
}

- (void)pauseButtonPressed {
    self.idbModel.paused = YES;
    return;
}

@end