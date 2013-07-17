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

@property (strong, readwrite) IDBView *view;
@property (strong, readwrite) IDBViewController *viewController;
@property (strong, readwrite) IDBNavigationController *navigationController;

+(IDBAppDelegate *)sharedAppDelegate;

@end