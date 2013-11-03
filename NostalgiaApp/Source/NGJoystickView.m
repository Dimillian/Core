//
//  NGJoystickView.m
//  NostalgiaApp
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NGJoystickView.h"
#import "NAControlViewSubclass.h"
#import "NGKey.h"

@implementation NGJoystickView

- (id)initWithRadius:(CGFloat)radius {
    UIBezierPath *shape = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0.0f endAngle:2.0f * M_PI clockwise:YES];
    if (self = [super initWithShape:shape]) {
        self.upKey = [NGKey keyWithScancode:SDL_SCANCODE_Q];
        self.downKey = [NGKey keyWithScancode:SDL_SCANCODE_A];
        self.rightKey = [NGKey keyWithScancode:SDL_SCANCODE_P];
        self.leftKey = [NGKey keyWithScancode:SDL_SCANCODE_O];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0f + self.bounds.origin.x,
                                 self.bounds.size.height / 2.0f + self.bounds.origin.y);
    CGPoint touchLocation = [touch locationInView:self];
    CGFloat slope = (touchLocation.y - center.y) / (touchLocation.x - center.x);
    
    if (fabs(slope) < tanf(3 * M_PI / 8)) {
        self.rightKey.isPressed = touchLocation.x > center.x;
        self.leftKey.isPressed = touchLocation.x < center.x;
    } else {
        self.rightKey.isPressed = NO;
        self.leftKey.isPressed = NO;
    }
    
    if (fabs(slope) > tanf(M_PI / 4)) {
        self.upKey.isPressed = touchLocation.y < center.y;
        self.downKey.isPressed = touchLocation.y > center.y;
    } else {
        self.upKey.isPressed = NO;
        self.downKey.isPressed = NO;
    }
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.upKey.isPressed = NO;
    self.downKey.isPressed = NO;
    self.rightKey.isPressed = NO;
    self.leftKey.isPressed = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self touchesEnded:touches withEvent:event];
}

@end