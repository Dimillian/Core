//
//  IDBNavigationController.m
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBNavigationController.h"

@interface IDBNavigationController ()

@end

@implementation IDBNavigationController

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide navigation bar
    self.navigationBarHidden = YES;
    
    // only show status bar on iPad
    [UIApplication sharedApplication].statusBarHidden = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    
    // stop tool bar appearance from resizing view
    //self.toolbar.translucent = YES;
}

@end
