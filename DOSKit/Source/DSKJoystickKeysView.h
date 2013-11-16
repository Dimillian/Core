//
//  NAKeyboardJoystick.h
//  NostalgiaApp
//
//  Created by user on 11/10/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSKJoystickView.h"

@interface DSKJoystickKeysView : DSKJoystickView

@property (readwrite, nonatomic) IDBKey *upKey;
@property (readwrite, nonatomic) IDBKey *downKey;
@property (readwrite, nonatomic) IDBKey *rightKey;
@property (readwrite, nonatomic) IDBKey *leftKey;

@end
