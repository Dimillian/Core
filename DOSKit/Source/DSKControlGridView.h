//
//  NAControlGridView.h
//  NostalgiaApp
//
//  Created by user on 11/9/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSKNAControlView.h"

@interface DSKControlGridView : UIView <NAControlViewDelegate>

@property (readwrite, nonatomic) BOOL isLocked;

@end