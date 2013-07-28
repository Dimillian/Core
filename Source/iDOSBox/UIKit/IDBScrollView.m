//
//  IDBScrollView.m
//  iDOSBox
//
//  Created by user on 7/28/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBScrollView.h"
#import "SDL_uikitview.h"

@interface IDBScrollView ()

@property (readwrite, nonatomic) SDL_uikitview *sdlView;

@end

@implementation IDBScrollView

- (id)initWithFrame:(CGRect)frame andSDLView:(SDL_uikitview *)sdlView {
    if (self = [super initWithFrame:frame]) {
        _sdlView = sdlView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // scale DOS layer view to fit screen while maintaing aspect ratio
    CGFloat aspectRatio = self.sdlView.bounds.size.width / self.sdlView.bounds.size.height;
    
    CGRect screenRect = [UIScreen mainScreen].applicationFrame;
    
    if (screenRect.size.width / aspectRatio <= screenRect.size.height) {
        self.sdlView.frame = CGRectMake(0.0f, 0.0f, screenRect.size.width, screenRect.size.width / aspectRatio);
    } else {
        self.sdlView.frame = CGRectMake(0.0f, 0.0f, screenRect.size.height, screenRect.size.height / aspectRatio);
    }
    
    self.sdlView.center = self.center;
    // center SDL view
    /*
    CGSize containerBoundsSize = self.bounds.size;
    CGRect frameToCenter = self.sdlView.frame;
    
    if (frameToCenter.size.height < containerBoundsSize.height) {
        frameToCenter.origin.y = (containerBoundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    self.sdlView.frame = frameToCenter;
    */
     
    self.contentSize = self.sdlView.bounds.size;
}

@end
