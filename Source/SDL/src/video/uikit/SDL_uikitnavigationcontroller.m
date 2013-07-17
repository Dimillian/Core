//
//  SDL_uikitnavigationcontroller.m
//  iDOSBox
//
//  Created by user on 7/16/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "SDL_uikitnavigationcontroller.h"

#ifdef IDOSBOX

@implementation SDL_uikitnavigationcontroller

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}

@end

#endif