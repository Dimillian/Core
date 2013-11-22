//
//  NAControlView.h
//  NostalgiaApp
//
//  Created by user on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSKNAControlView;

@protocol NAControlViewDelegate <NSObject>

@required
@property (readwrite, nonatomic) BOOL isLocked;

@optional
- (void)controlViewDragBegan:(DSKNAControlView *)controlView withTouches:(NSSet *)touches;
- (void)controlViewDragMoved:(DSKNAControlView *)controlView withTouches:(NSSet *)touches;
- (void)controlViewDragEnded:(DSKNAControlView *)controlView withTouches:(NSSet *)touches;
- (void)controlViewDragCancelled:(DSKNAControlView *)controlView withTouches:(NSSet *)touches;

@end

@interface DSKNAControlView : UIView

@property (weak, readwrite, nonatomic) id <NAControlViewDelegate> delegate;
@property (readwrite, nonatomic) CGPoint touchOffset;

- (id)initWithShape:(UIBezierPath *)aShape;
- (void)animateScale:(CGFloat)scale;
- (CGPoint)boundsCenter;

@end