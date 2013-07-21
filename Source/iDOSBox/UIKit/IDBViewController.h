//
//  IDBViewController.h
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDBView;

@interface IDBViewController : UIViewController

@property (readonly, nonatomic) UIScrollView *scrollView;
@property (readonly, nonatomic) IDBView *idbView;

- (id)initWithIDBView:(IDBView *)idbView;

@end
