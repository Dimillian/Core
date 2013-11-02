//
//  NGJoystickView.h
//  NostalgiaApp
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NAControlView.h"
#import "SDL_scancode.h"

@interface NGJoystickView : NAControlView

- (id)initWithRadius:(CGFloat)aRadius;

@property (readwrite, nonatomic) BOOL isKeyboardJoystick;
@property (readwrite, nonatomic) SDL_scancode upKey;
@property (readwrite, nonatomic) SDL_scancode downKey;
@property (readwrite, nonatomic) SDL_scancode rightKey;
@property (readwrite, nonatomic) SDL_scancode leftKey;

@end
