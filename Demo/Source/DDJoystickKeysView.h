//
//  NAKeyboardJoystick.h
//  NostalgiaApp
//
//  Created by user on 11/10/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDJoystickView.h"

@interface DDJoystickKeysView : DDJoystickView

@property (readwrite, nonatomic) DKKey *upKey;
@property (readwrite, nonatomic) DKKey *downKey;
@property (readwrite, nonatomic) DKKey *rightKey;
@property (readwrite, nonatomic) DKKey *leftKey;

@end
