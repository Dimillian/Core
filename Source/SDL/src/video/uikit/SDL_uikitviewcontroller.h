//
//  TestViewController.h
//  iDOSBox
//
//  Created by user on 7/15/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "SDL_config.h"

#ifdef IDOSBOX

#import <UIKit/UIKit.h>

@class SDL_uikitview;

@interface SDL_uikitviewcontroller : UIViewController

- (id)initWithSDLView:(SDL_uikitview *)sdlView;

@end

#endif