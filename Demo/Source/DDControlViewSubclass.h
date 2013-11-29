//
//  NAControlViewSubclass.h
//  NostalgiaApp
//
//  Created by user on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

@interface DDControlView ()

@property (readwrite, nonatomic) UIBezierPath *shape;
@property (readwrite, nonatomic) BOOL isPressed;

- (UIColor *)strokeColor;
- (UIColor *)fillColor;

@end