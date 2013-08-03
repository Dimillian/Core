//
//  IDBContainerViewController.h
//  iDOSBox
//
//  Created by user on 8/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDBViewController;
@class IDBTableViewController;

@interface IDBContainerViewController : UIViewController

- (id)initWithPrimaryViewController:(IDBViewController *)primaryViewController andSecondaryViewController:(IDBTableViewController *)secondaryViewController;

@end
