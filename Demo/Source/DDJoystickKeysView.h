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

@property (readwrite, nonatomic) DCKey *upKey;
@property (readwrite, nonatomic) DCKey *downKey;
@property (readwrite, nonatomic) DCKey *rightKey;
@property (readwrite, nonatomic) DCKey *leftKey;

@end
