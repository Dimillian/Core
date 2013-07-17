//
//  IDBViewController.m
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBViewController.h"
#import "IDBView.h"

@implementation IDBViewController

- (id)initWithIDBView:(IDBView *)idbView {
    if (self = [super init]) {
        self.view = idbView;
    }
    return self;
}

@end
