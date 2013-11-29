//
//  NAControlView.h
//  NostalgiaApp
//
//  Created by user on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDControlView;

@protocol DDControlViewDelegate <NSObject>

@required
@property (readwrite, nonatomic) BOOL isLocked;

@optional
- (void)controlViewDragBegan:(DDControlView *)controlView withTouches:(NSSet *)touches;
- (void)controlViewDragMoved:(DDControlView *)controlView withTouches:(NSSet *)touches;
- (void)controlViewDragEnded:(DDControlView *)controlView withTouches:(NSSet *)touches;
- (void)controlViewDragCancelled:(DDControlView *)controlView withTouches:(NSSet *)touches;

@end

@interface DDControlView : UIView

@property (weak, readwrite, nonatomic) id <DDControlViewDelegate> delegate;
@property (readwrite, nonatomic) CGPoint touchOffset;

- (id)initWithShape:(UIBezierPath *)aShape;
- (void)animateScale:(CGFloat)scale;
- (CGPoint)boundsCenter;

@end