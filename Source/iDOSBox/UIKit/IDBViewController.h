//
//  IDBViewController.h
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDBModel;
@class SDL_uikitopenglview;

@interface IDBViewController : UIViewController

@property (readonly, nonatomic) SDL_uikitopenglview *sdlView;

- (id)initWithIDBModel:(IDBModel *)model andSDLView:(SDL_uikitopenglview *)sdlView;

@end
