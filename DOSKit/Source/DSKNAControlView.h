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
- (void)controlView:(DSKNAControlView *)controlView touchesBegan:(NSSet *)touches;
- (void)controlView:(DSKNAControlView *)controlView touchesMoved:(NSSet *)touches;
- (void)controlView:(DSKNAControlView *)controlView touchesEnded:(NSSet *)touches;
- (void)controlView:(DSKNAControlView *)controlView touchesCancelled:(NSSet *)touches;

@end

@interface DSKNAControlView : UIView

@property (weak, readwrite, nonatomic) id <NAControlViewDelegate> delegate;
@property (readwrite, nonatomic) CGPoint touchOffset;

- (id)initWithShape:(UIBezierPath *)aShape;
- (CGPoint)boundsCenter;

@end