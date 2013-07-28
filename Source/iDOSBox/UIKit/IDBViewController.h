//
//  IDBViewController.h
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDL_uikitopenglview;

@interface IDBViewController : UIViewController <UIScrollViewDelegate>

@property (readonly, nonatomic) UIScrollView *scrollView;
@property (readonly, nonatomic) SDL_uikitopenglview *sdlView;

- (id)initWithSDLView:(SDL_uikitopenglview *)sdlView;

@end
