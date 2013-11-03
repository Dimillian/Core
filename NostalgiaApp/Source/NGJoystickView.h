//
//  NGJoystickView.h
//  NostalgiaApp
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NAControlView.h"

@class NGKey;

@interface NGJoystickView : NAControlView

- (id)initWithRadius:(CGFloat)radius;

@property (readwrite, nonatomic) BOOL isKeyboardJoystick;
@property (readwrite, nonatomic) NGKey *upKey;
@property (readwrite, nonatomic) NGKey *downKey;
@property (readwrite, nonatomic) NGKey *rightKey;
@property (readwrite, nonatomic) NGKey *leftKey;

@end
