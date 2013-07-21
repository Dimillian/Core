//
//  IDBAppDelegate.h
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "SDL_uikitappdelegate.h"

@class IDBView;
@class IDBViewController;
@class IDBNavigationController;

@interface IDBAppDelegate : SDLUIKitDelegate

@property (readwrite, nonatomic) IDBView *view;
@property (readwrite, nonatomic) IDBViewController *viewController;
@property (readwrite, nonatomic) IDBNavigationController *navigationController;

+(IDBAppDelegate *)sharedAppDelegate;

@end