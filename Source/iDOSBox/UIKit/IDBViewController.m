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

@property (readwrite, nonatomic) BOOL isKeyboardVisible;
@property (readwrite, nonatomic) UIScrollView *scrollView;
@property (readwrite, nonatomic) SDL_uikitopenglview *sdlView;

@end

@implementation IDBViewController

- (id)initWithSDLView:(SDL_uikitopenglview *)sdlView {
    if (self = [super init]) {
        _sdlView = sdlView;
        _isKeyboardVisible = NO;
    }
    return self;
}

- (void)loadView {
    // don't call super because view is created programatically
    // setup SDL view
    self.sdlView.layer.magnificationFilter = kCAFilterNearest;
    //self.sdlView.contentMode = UIViewContentModeScaleAspectFit;
    //self.sdlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.sdlView addGestureRecognizer:singleTapRecognizer];
    
    // setup view
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
    // setup scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    //self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.sdlView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // scale DOS layer view to fit screen while maintaing aspect ratio
    CGFloat aspectRatio = self.sdlView.bounds.size.width / self.sdlView.bounds.size.height;
    
    if (self.view.bounds.size.width / aspectRatio <= self.view.bounds.size.height) {
        self.sdlView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.width / aspectRatio);
    } else {
        self.sdlView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.height, self.view.bounds.size.height / aspectRatio);
    }
    
    self.scrollView.contentSize = self.sdlView.bounds.size;
}
 
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShowOrHide:(NSNotification *)aNotification {
    // get keyboard values
    CGRect keyboardFrame = [[aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // keyboard orientation is always returned in portrait orientation coordinates, so it must be converted to the local orientation
    CGRect adjustedKeyboardFrame = [self.view convertRect:keyboardFrame toView:nil];
    
    if ([aNotification.name isEqualToString:UIKeyboardWillShowNotification]) {
        NSLog(@"keyboard show");
        
        if (!self.isKeyboardVisible) {
            self.isKeyboardVisible = YES;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:animationCurve];
            
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, adjustedKeyboardFrame.size.height, 0.0f);
            self.scrollView.contentInset = contentInsets;
            self.scrollView.scrollIndicatorInsets = contentInsets;
            
            [UIView commitAnimations];
            
            CGPoint contentOffset = CGPointMake(0, self.scrollView.contentSize.height - (self.scrollView.bounds.size.height - adjustedKeyboardFrame.size.height));
            [self.scrollView setContentOffset:contentOffset animated:YES];

        }
    } else if ([aNotification.name isEqualToString:UIKeyboardWillHideNotification]) {
        NSLog(@"keyboard hide");
        
        if (self.isKeyboardVisible) {
            self.isKeyboardVisible = NO;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:animationCurve];
            
            self.scrollView.contentInset = UIEdgeInsetsZero;
            
            [UIView commitAnimations];
        }
    }
    

}

- (void)singleTap {
    if (!self.isKeyboardVisible) {
        [self.sdlView showKeyboard];
    } else {
        [self.sdlView hideKeyboard];
    }
}

@end