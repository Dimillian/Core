//
//  IDBViewController.h
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDL_uikitview;

@interface IDBViewController : UIViewController <UIScrollViewDelegate>

- (id)initWithSDLView:(SDL_uikitview *)sdlView;

@end
