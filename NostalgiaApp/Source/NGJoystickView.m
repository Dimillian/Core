//
//  NGJoystickView.m
//  NostalgiaApp
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NGJoystickView.h"

@implementation NGJoystickView

- (id)initWithRadius:(CGFloat)aRadius {
    self = [super initWithShape:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, aRadius * 2.0f, aRadius * 2.0f) cornerRadius:aRadius]];
    return self;
}

@end