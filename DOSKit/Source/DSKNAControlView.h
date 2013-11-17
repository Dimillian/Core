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
- (void)controlView:(DSKNAControlView *)controlView touchBegan:(CGPoint)touchLocation;
- (void)controlView:(DSKNAControlView *)controlView touchMoved:(CGPoint)touchLocation;
- (void)controlView:(DSKNAControlView *)controlView touchEnded:(CGPoint)touchLocation;
- (void)controlView:(DSKNAControlView *)controlView touchCancelled:(CGPoint)touchLocation;

@end

@interface DSKNAControlView : UIView

- (CGPoint)boundsCenter;
@property (weak, readwrite, nonatomic) id <NAControlViewDelegate> delegate;

- (id)initWithShape:(UIBezierPath *)aShape;

@end