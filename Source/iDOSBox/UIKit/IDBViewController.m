//
//  IDBViewController.m
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBViewController.h"
#import "IDBView.h"
#import "QuartzCore/CALayer.h"

@interface IDBViewController ()

@property (readwrite, nonatomic) CGRect applicationFrame;
@property (readwrite, nonatomic) BOOL isKeyboardVisible;
@property (readwrite, nonatomic) UIScrollView *scrollView;
@property (readwrite, nonatomic) IDBView *idbView;

@end

@implementation IDBViewController

- (id)initWithIDBView:(IDBView *)idbView {
    if (self = [super init]) {
        _idbView = idbView;
        self.applicationFrame = [UIScreen mainScreen].applicationFrame;
        _isKeyboardVisible = NO;
    }
    return self;
}

- (void)loadView {
    /* don't call super because view is created programatically */
    
    //self.idbView.frame = self.applicationFrame;
    //self.idbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //self.idbView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.applicationFrame];
    self.scrollView.clipsToBounds = YES;
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.idbView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.contentSize = self.idbView.bounds.size; //CGSizeMake(self.applicationFrame.size.height, self.applicationFrame.size.width);
    
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.scrollView addSubview:self.idbView];
    
    [self.idbView.layer setMagnificationFilter:kCAFilterNearest];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.idbView addGestureRecognizer:singleTapRecognizer];
}

/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.scrollView.frame = CGRectMake(0, 0, 100, 100);
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.scrollView.contentSize = CGSizeMake(self.applicationFrame.size.height, self.applicationFrame.size.width);
    } else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        
    }
    return;
}
 */

- (void)keyboardWillShow:(NSNotification *)aNotification {
    CGRect keyboardBounds;
    NSValue *beginValue = [aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    [beginValue getValue:&keyboardBounds];
    
    if (!self.isKeyboardVisible) {
        self.isKeyboardVisible = YES;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height - keyboardBounds.size.width);
        [UIView commitAnimations];
        
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height) animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGRect keyboardBounds;
    NSValue *beginValue = [aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    [beginValue getValue:&keyboardBounds];
    
    if (self.isKeyboardVisible) {
        self.isKeyboardVisible = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height + keyboardBounds.size.width);
        [UIView commitAnimations];
        
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)singleTap {
    if (!self.isKeyboardVisible) {
        [self.idbView showKeyboard];
    } else {
        [self.idbView hideKeyboard];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end