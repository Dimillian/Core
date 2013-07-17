//
//  TestViewController.m
//  iDOSBox
//
//  Created by user on 7/15/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "SDL_uikitviewcontroller.h"

#ifdef IDOSBOX

#import "SDL_uikitview.h"

@interface SDL_uikitviewcontroller ()

@end

@implementation SDL_uikitviewcontroller

- (id)initWithSDLView:(SDL_uikitview *)sdlView {
    if (self = [super init]) {
        self.view = sdlView;
    }
    return self;
}

@end

#endif