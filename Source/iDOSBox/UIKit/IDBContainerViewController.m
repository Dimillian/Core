//
//  IDBContainerViewController.m
//  iDOSBox
//
//  Created by user on 8/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBContainerViewController.h"
#import "IDBViewController.h"
#import "IDBTableViewController.h"

@interface IDBContainerViewController ()

@property (readwrite, nonatomic) IDBViewController *primaryViewController;
@property (readwrite, nonatomic) IDBTableViewController *secondaryViewController;

@end

@implementation IDBContainerViewController

- (id)initWithPrimaryViewController:(IDBViewController *)primaryViewController andSecondaryViewController:(IDBTableViewController *)secondaryViewController {
    if (self = [super init]) {
        _primaryViewController = primaryViewController;
        _secondaryViewController = secondaryViewController;
    }
    return self;
}

- (void)loadView {
    // don't call [super loadView] because view is created programatically
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.primaryViewController];
    [self.view addSubview:self.primaryViewController.view];
    [self.primaryViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.secondaryViewController];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self.primaryViewController.view addGestureRecognizer:swipeGestureRecognizer];
    return;
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                                self.primaryViewController.view.frame = CGRectMake(250.0f, 0.0f, self.primaryViewController.view.frame.size.width, self.primaryViewController.view.    frame.size.height);
                                }
                     completion:NULL];
}

@end