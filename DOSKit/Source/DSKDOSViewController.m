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

#import "DSKDOSViewController.h"
#import "DSKDOSModel.h"
#import "DSKDOSView.h"
#import "DSKControlGridView.h"

@interface DSKDOSViewController ()

@property (readwrite, nonatomic) DSKDOSModel *dosModel;
@property (readwrite, nonatomic) DSKControlGridView *controlGridView;
@property (readwrite, nonatomic) DSKDOSView *dosView;
@property (readwrite, nonatomic) BOOL menuVisible;
@property (readwrite, nonatomic) BOOL menuOpen;

@end

@implementation DSKDOSViewController

- (id)initWithIDBModel:(DSKDOSModel *)dosModel andDOSView:(DSKDOSView *)dosView {
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
    self.controlGridView = [[DSKControlGridView alloc] initWithFrame:self.view.bounds];
    
    [self.dosView setFrame:self.view.bounds];
    self.dosView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.controlGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.dosView];
    [self.view addSubview:self.controlGridView];
    
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
        
    UIBarButtonItem *joystickButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"JoystickIcon.png"]
                                                         landscapeImagePhone:[UIImage imageNamed:@"JoystickIcon.png"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(hideButtonPressed)];
    
    UIBarButtonItem *keyboardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KeyboardIcon.png"]
                                                         landscapeImagePhone:[UIImage imageNamed:@"KeyboardIcon.png"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(hideButtonPressed)];

    UIBarButtonItem *muteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UnmuteIcon.png"]
                                                         landscapeImagePhone:[UIImage imageNamed:@"UnmuteIcon.png"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(hideButtonPressed)];
    
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PauseIcon.png"]
                                                     landscapeImagePhone:[UIImage imageNamed:@"PauseIcon.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(playPausePressed:)];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[joystickButton, muteButton, keyboardButton, flexibleSpace, playButton];
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
    self.controlGridView.isLocked = !self.controlGridView.isLocked;
    self.menuVisible = !self.menuVisible;
    self.menuOpen = !self.menuOpen;
    return;
}

- (void)playPausePressed:(UIBarButtonItem *)playButton {
    self.dosModel.paused = !self.dosModel.paused;
    if (self.dosModel.paused) {
        [playButton setImage:[UIImage imageNamed:@"PlayIcon.png"]];
        [playButton setLandscapeImagePhone:[UIImage imageNamed:@"PlayIcon.png"]];
    } else {
        [playButton setImage:[UIImage imageNamed:@"PauseIcon.png"]];
        [playButton setLandscapeImagePhone:[UIImage imageNamed:@"PauseIcon.png"]];
    }
    return;
}

@end