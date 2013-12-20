/*
 * DOSCode
 * Copyright (C) 2013  Matthew Vilim
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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