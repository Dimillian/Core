//
//  IDBScrollView.h
//  iDOSBox
//
//  Created by user on 7/28/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDL_uikitview;

@interface IDBScrollView : UIScrollView

- (id)initWithFrame:(CGRect)frame andSDLView:(SDL_uikitview *)sdlView;

@end