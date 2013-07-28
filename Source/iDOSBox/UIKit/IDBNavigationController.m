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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
        
    [[UIApplication sharedApplication] setStatusBarHidden:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone];
}

@end
