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

@property (readwrite, nonatomic) UIScrollView *scrollView;
@property (readwrite, nonatomic) IDBView *idbView;

@end

@implementation IDBViewController

- (id)initWithIDBView:(IDBView *)idbView {
    if (self = [super init]) {
        _idbView = idbView;
    }
    return self;
}

- (void)loadView {
    /* don't call super because view is created programatically */
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    self.idbView.frame = screenBounds;
    self.idbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.idbView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = screenBounds.size;
    [self.scrollView addSubview:self.idbView];
    
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.idbView.layer setMagnificationFilter:kCAFilterNearest];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.idbView addGestureRecognizer:singleTapRecognizer];
}

- (void)singleTap {
    if (!self.idbView.keyboardVisible) {
        [self.idbView showKeyboard];
    } else {
        [self.idbView hideKeyboard];
    }
}

@end