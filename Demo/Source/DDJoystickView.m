//
//  NGJoystickView.m
//  NostalgiaApp
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DDJoystickView.h"
#import "DDControlViewSubclass.h"

@implementation DDJoystickView

- (id)initWithRadius:(CGFloat)radius {
    NSAssert(![self isMemberOfClass:[DDJoystickView class]], DKShouldOverrideError);
    UIBezierPath *shape = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0.0f endAngle:2.0f * M_PI clockwise:YES];
    return self = [super initWithShape:shape];
}

@end