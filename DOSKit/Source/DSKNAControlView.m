//
//  NAControlView.m
//  NostalgiaApp
//
//  Created by user on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DSKNAControlView.h"
#import "DSKControlViewSubclass.h"

@interface DSKNAControlView ()

@end

@implementation DSKNAControlView

- (id)initWithShape:(UIBezierPath *)aShape {
    NSAssert(![self isMemberOfClass:[DSKNAControlView class]], IDBShouldOverrideError);
    if (self = [super initWithFrame:aShape.bounds]) {
        _shape = aShape;
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat strokeWidth = 5.0f;
    
    // inner stroke
    CGContextSaveGState(context); {
        // clip
        CGContextBeginPath(context);
        CGContextAddPath(context, self.shape.CGPath);
        CGContextClip(context);
        // stroke
        CGContextAddPath(context, self.shape.CGPath);
        CGContextSetStrokeColorWithColor(context, [self strokeColor].CGColor);
        CGContextSetLineWidth(context, strokeWidth);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    // fill inside inner stroke
    CGContextSaveGState(context); {
        // clip
        CGContextBeginPath(context);
        CGContextAddPath(context, self.shape.CGPath);
        CGContextSetLineWidth(context, strokeWidth);
        CGContextReplacePathWithStrokedPath(context);
        CGContextAddRect(context, CGRectInfinite);
        CGContextClip(context);
        // fill
        CGContextAddPath(context, self.shape.CGPath);
        CGContextSetFillColorWithColor(context, [self fillColor].CGColor);
        CGContextFillPath(context);
    } CGContextRestoreGState(context);
}

- (CGPoint)boundsCenter {
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlView:self touchesBegan:touches];
    self.isPressed = YES;
    if (!self.delegate.isLocked) {
        //[self.shape applyTransform:CGAffineTransformMakeScale(2.0f, 2.0f)];
        //self.bounds = self.shape.bounds;
        
        CATransform3D transform = CATransform3DMakeScale(2.0f, 2.0f, 1.0f);
        CABasicAnimation* animation;
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        // Now assign the transform as the animation's value. While
        // animating, CABasicAnimation will vary the transform
        // attribute of its target, which for this transform will spin
        // the target like a wheel on its z-axis.
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        
        animation.duration = 2;  // two seconds
        animation.cumulative = YES;
        animation.repeatCount = 10000;
        [self.layer addAnimation:animation forKey:nil];
    }
    [self setNeedsDisplay];
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlView:self touchesMoved:touches];
    UITouch *touch = [[event allTouches] anyObject];
    if (![self.shape containsPoint:[touch locationInView:self]]) {
        self.isPressed = NO;
        [self setNeedsDisplay];
    }
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlView:self touchesEnded:touches];
    self.isPressed = NO;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlView:self touchesCancelled:touches];
    [self touchesEnded:touches withEvent:event];
}

- (UIColor *)strokeColor {
    CGFloat alpha = self.isPressed ? 0.8f : 0.6f;
    return [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
}

- (UIColor *)fillColor {
    CGFloat alpha = self.isPressed ? 0.6f : 0.4f;
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alpha];
}

@end
